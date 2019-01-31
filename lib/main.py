class Board:
	def __init__(self, size):
		self.board = [[0 for i in range(size)] for j in range(size)]
		self.size = size
		self.turn = 10

	def __str__(self):
		s = '   '

		#Adds ABC
		for i in range(1, self.size+1):
			s += '{2:}'.format(i)
		s += '\n'

		for col in range(self.size):
			for row in range(self.size):
				if self.board[row][col] == 0:
					s += ' .'
				elif 10 <= self.board[row][col] <= 18:
					s += ' B'
				elif self.board[row][col] == 19:
					s += ' b'
				elif 20 <= self.board[row][col] <= 28:
					s += ' W'
				else:
					s += ' w'
			s += '\n'

		return s

	def print_array(self):
		s = 'Board:\n'

		for col in range(self.size):
			for row in range(self.size):
				s += "{:3}".format(str(self.board[row][col]))
			s += '\n'

		return s

	def _remove_captures(self):
		for row in range(self.size):
			for col in range(self.size):
				if (self.board[row][col]-9) % 10 == 0:
					print("Removed captures at ({},{})".format(row, col))
					self.board[row][col] = 0

	def _reset_liberty_marks(self):
		for row in range(self.size):
			for col in range(self.size):
				if (self.board[row][col]-9) % 10 == 0:
					print("Reset mark at ({},{})".format(row, col))
					self.board[row][col] -= 9

	def _has_liberties(self, row, col):
		print("Beginn to check ({},{})".format(row, col))
		# there are no liberties on the coledge
		if row < 0 or col < 0:
			return False

		# there is a liberty
		if self.board[row][col] == 0:
			return True

		# this spot has been checked before
		if self.board[row][col] == 19 or self.board[row][col] == 29:
			return False

		# mark that this stone has been checked before
		self.board[row][col] = self.turn + 9

		# check all four adjacent sides for liberties
		if self._has_liberties(row, col-1):
			return True
		if self._has_liberties(row, col+1):
			return True
		if self._has_liberties(row-1, col):
			return True
		if self._has_liberties(row+1, col):
			return True

		print("({},{}) has no liberties!".format(row, col))
		return False

	def opposite_turn(self):
		if self.turn == 10:
			return 20
		else:
			return 10

	def _check_spot(self, row, col):
		if self._has_liberties(row, col):
			self._reset_liberty_marks()
		else:
			self._remove_captures()

	def move(self, row, col):
		# spot already ocupied
		if self.board[row][col] != 0:
			print('This spot is already occupied or Ko!')
			return False

		self.board[row][col] = self.turn

		# self._check_spot(row, col-1)
		# self._check_spot(row, col+1)
		# self._check_spot(row-1, col)
		# self._check_spot(row+1, col)

		return True

	def player_input(self):
		try:
			x = int(input("x> "))
			if x == 25:
				print(self.print_array())
				return False
			if 0 < x > self.size:
				print("x not in bound!")
				return False
			y = int(input("y> "))
			if 0 < y > self.size:
				print("x not in bound!")
				return False
			return x-1, y-1
		except KeyboardInterrupt:
			print("\nBye!")
			exit()
		except:
			print('Input Invalid!')
			return False


## TESTING

b = Board(19)

while True:

	print(b)
	i = b.player_input()
	if not i:
		continue
	else:
		x, y = i

	if not b.move(x, y):
		continue

	b.turn = b.opposite_turn()
