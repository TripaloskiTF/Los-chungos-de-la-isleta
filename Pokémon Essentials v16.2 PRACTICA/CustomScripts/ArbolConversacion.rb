class Nodo
	attr_accessor :ID, :Texto, :Modificador, :Padre, :Hijos, :NumeroHijos, :Nivel
	def initialize (_ID, _Texto, _Modificador, _Padre, _Nivel)
		@ID = _ID
		@Padre = _Padre
		@Texto = _Texto
		@Modificador = _Modificador
		@Nivel = _Nivel
		@Hijos = []
		@NumeroHijos = 0
	end

	def SetPadre(padre)
		@Padre = padre
	end

	def AddHijo(hijo)
		@Hijos << hijo
		@NumeroHijos += 1
	end

	def AddHijos (hijos)
		hijos.each do |hijo|
			@Hijos << hijo
			@NumeroHijos += 1
		end
	end
end

$TEXT = 0
$VALUE = 1

$CHILD = 2

$PREV = 1
$INPUT = 2
$NEXT = 3

class Arbol
	attr_accessor :Root, :Profundidad
	@@ID = 0

	def initialize (file)
		@Profundidad = 0
		self.Import(file)
	end

	def AddHijo (texto, valor)
		@@ID += 1
		@Root.AddHijo(Nodo.new(@@ID, texto, valor, @Root, @Profundidad))
	end

	def AddHijo (texto, valor, id)
		@Root.AddHijo(Nodo.new(id, texto, valor, @Root, @Profundidad))
	end

	def NextLevel (option)
		if @Root.Hijos[option] != nil
			@Root = @Root.Hijos[option]
			@Profundidad += 1
		end
	end

	def PrevLevel ()
		if @Profundidad > 0
			@Root = @Root.Padre
			@Profundidad -= 1
		end
	end

	def Import(fileName)
		ids = 0
		File.open(fileName).readlines.each do |line|
			aux = line.split

			if ids == 0
				@Root = Nodo.new(ids, aux[$TEXT], aux[$VALUE], nil, 0)
				ids += 1
			else
				case aux.length
				when $PREV
					self.PrevLevel()

				when $INPUT
					self.AddHijo(aux[$TEXT], aux[$VALUE], ids)
					ids += 1

				when $NEXT
					self.NextLevel(Integer(aux[$CHILD]))
				else
					puts("NO HA PASADO NADA")
				end
			end
		end
		self.RestoreRoot()
	end

	def Export(fileName)
		puts "Algo"
	end

	def Print
		cola = Queue.new
		cola.push(@Root)
		while !cola.empty? do
			aux = cola.pop()
			banner = "--" * aux.Nivel
			if aux.Padre != nil
				if aux.Padre.ID == 0
					puts("#{banner}-ID=#{aux.ID}[SON_OF:ROOT]:#{aux.Texto} (#{aux.Modificador})")
				else
					puts("#{banner}-ID=#{aux.ID}[SON_OF:#{aux.Padre.ID}]:#{aux.Texto} (#{aux.Modificador})")
				end
			else
				puts("#{banner}-[ROOT]:#{aux.Texto} (#{aux.Modificador})")
			end

			aux.Hijos.each do |hijo|
				cola.push(hijo)
			end
		end
	end

	def RestoreRoot
		while @Root.Padre != nil do
			@Root = @Root.Padre
		end
	end
end

=begin
arbol = Arbol.new("Hola que tal", 0)
arbol.AddHijo("Me llamo Paca", 10)
arbol.AddHijo("Me llamo Francisca", -10)

arbol.NextLevel(0)

arbol.AddHijo("Adios Paca", 0)

arbol.PrevLevel()
arbol.NextLevel(1)

arbol.AddHijo("Adios Francisca", 5)
arbol.AddHijo("Chao Pescao", -5)

arbol.RestoreRoot()
arbol.Print()

puts("\n")
=end

arbol = Arbol.new('arbol1.arb')
arbol.Print()
