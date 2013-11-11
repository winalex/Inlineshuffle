/*
The MIT License
 
Copyright (c) 2011 Jackson Dunstan
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package flash.geom
{
	import flash.geom.Vector3D;
 
	/**
	*   A Vector3D with extended functionality
	*   @author Jackson Dunstan (jacksondunstan.com)
	*/
	public class Vector3DExt extends Vector3D
	{
		/** The origin point in 3D. That is (0, 0, 0, 1) */
		static public const ORIGIN:Vector3DExt = new Vector3DExt(0.0, 0.0, 0.0, 1.0);
 
		/** The zero vector. That is (0, 0, 0, 0). */
		static public const ZERO_VECTOR:Vector3DExt = new Vector3DExt(0.0, 0.0, 0.0, 0.0);
 
		/** The negative X axis. That is (-1, 0, 0, 0). */
		static public const NEGATIVE_X_AXIS:Vector3DExt = new Vector3DExt(-1.0, 0.0, 0.0, 0.0);
 
		/** The negative Y axis. That is (0, -1, 0, 0). */
		static public const NEGATIVE_Y_AXIS:Vector3DExt = new Vector3DExt(0.0, -1.0, 0.0, 0.0);
 
		/** The negative Z axis. That is (0, 0, -1, 0). */
		static public const NEGATIVE_Z_AXIS:Vector3DExt = new Vector3DExt(0.0, 0.0, -1.0, 0.0);
		
		
		private var _unit:Vector3D;
		
 
		/**
		*   The the vector, optionally with some or all initial components
		*   @param x (optional) X component. Defaults to zero.
		*   @param y (optional) Y component. Defaults to zero.
		*   @param z (optional) Z component. Defaults to zero.
		*   @param w (optional) W component. Defaults to zero.
		*/
		public function Vector3DExt(
			x:Number = 0.0,
			y:Number = 0.0,
			z:Number = 0.0,
			w:Number = 0.0
		)
		{
			super(x, y, z, w);
		}
 
		/**
		*   Check if this vector is a 3D vector. A 3D vector must have a W
		*   component of zero. This is not true for 3D points (W=1) or
		*   true in general for 4D vectors and points(W not always 0).
		*   @return If this vector is a 3D vector
		*/
		public function get is3DVector(): Boolean
		{
			return w == 0.0;
		}
 
		/**
		*   Check if this vector is a 3D point. A 3D point must have a W
		*   component of one. This is not true for 3D vectors (W=0) or
		*   true in general for 4D vectors and points (W not always 0).
		*   @return If this vector is a 3D point
		*/
		public function get is3DPoint(): Boolean
		{
			return w == 1.0;
		}
 
		/**
		*   Check if this vector is valid and therefore does not contain any
		*   component that is NaN
		*   @return If this vector is valid
		*/
		public function get isValid(): Boolean
		{
			// A Number does not equal itself only when it is NaN. This is
			// therefore an optimization to calling the global isNaN() function.
			return x==x && y==y && z==z && w==w;
		}
		
		
		/**
		* 		unit
		*/
		public function get unit():Vector3D 
		{
			if (!_unit) {
				_unit = this.clone();
				_unit.normalize();
			}
        
			return _unit;
       
		}
 
		/**
		*   This version return a Vector3DExt
		*   @inheritDoc
		*/
		override public function add(a:Vector3D): Vector3D
		{
			return new Vector3DExt(
				x + a.x,
				y + a.y,
				z + a.z,
				0.0
			);
		}
 
		/**
		*   This version return a Vector3DExt
		*   @inheritDoc
		*/
		public function add4D(a:Vector3D): Vector3D
		{
			return new Vector3DExt(
				x + a.x,
				y + a.y,
				z + a.z,
				w + a.w
			);
		}
 
		/**
		*   This version returns a Vector3DExt
		*   @inheritDoc
		*/
		override public function clone(): Vector3D
		{
			return new Vector3DExt(x, y, z, w);
		}
 
		/**
		*   Copy the components of the given vector to this vector. This version
		*   includes W.
		*   @param sourceVector3D Vector to copy from. Must not be null.
		*   @throws TypeError If 'sourceVector3D' is null
		*/
		public function copyFrom4D(sourceVector3D:Vector3D): void
		{
			x = sourceVector3D.x;
			y = sourceVector3D.y;
			z = sourceVector3D.z;
			w = sourceVector3D.w;
		}
 
		/**
		*   This version returns a Vector3DExt
		*   @inheritDoc
		*/
		override public function crossProduct(a:Vector3D): Vector3D
		{
			return new Vector3DExt(
				y*a.z - a.y*z,
				z*a.x - a.z*x,
				x*a.y - a.x*y,
				0.0
			);
		}
 
		/**
		*   Compute the cross product of this vector with another and store the
		*   result in a third vector which must NOT be this vector or the given
		*   vector to compute the cross product with or the components of the
		*   resulting vector will be incorrect. The W component of 'into'
		*   is set to zero regardless.
		*   @param a Vector to compute the cross product with. Must not be null,
		*            this vector, or 'into'.
		*   @param into Vector to store the result in. Must not be null, this
		*               vector, or 'a'.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function crossProductIntoFast(a:Vector3D, into:Vector3D): void
		{
			into.x = y*a.z - a.y*z;
			into.y = z*a.x - a.z*x;
			into.z = x*a.y - a.x*y;
			into.w = 0.0;
		}
 
		/**
		*   Compute the cross product of this vector with another and store the
		*   result in a third vector which can be any non-null vector. The W
		*   component of 'into' is set to zero.
		*   @param a Vector to compute the cross product with. Must not be null.
		*            May be this vector, 'into', or any other non-null vector.
		*   @param into Vector to store the result in. Must not be null. May be
		*               this vector, 'a', or any other non-null vector.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function crossProductIntoSafe(a:Vector3D, into:Vector3D): void
		{
			var resultX:Number = y*a.z - a.y*z;
			var resultY:Number = z*a.x - a.z*x;
			var resultZ:Number = x*a.y - a.x*y;
 
			into.x = resultX;
			into.y = resultY;
			into.z = resultZ;
			into.w = 0.0;
		}
 
		/**
		*   Subtract component-wise a given vector from this vector and store
		*   the result in a third vector. The W component of 'into' is copied
		*   from this vector without subtraction.
		*   @param a Vector to subtract from this vector. Must not be null.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function decrementByInto(a:Vector3D, into:Vector3D): void
		{
			into.x = x - a.x;
			into.y = y - a.y;
			into.z = z - a.z;
			into.w = w;
		}
 
		/**
		*   Subtract component-wise a given vector from this vector. This
		*   version includes the W component.
		*   @param a Vector to subtract from this vector. Must not be null.
		*   @throws TypeError If 'a' is null
		*/
		public function decrementBy4D(a:Vector3D): void
		{
			x -= a.x;
			y -= a.y;
			z -= a.z;
			w -= a.w;
		}
 
		/**
		*   Subtract component-wise a given vector from this vector and store
		*   the result in a third vector. This version includes the W component.
		*   @param a Vector to subtract from this vector. Must not be null.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function decrementBy4DInto(a:Vector3D, into:Vector3D): void
		{
			into.x = x - a.x;
			into.y = y - a.y;
			into.z = z - a.z;
			into.w = w - a.w;
		}
 
		/**
		*   Compute the distance between two 4D points and therefore includes
		*   the W component.
		*   @param pt1 First vector. Must not be null.
		*   @param pt2 Second vector. Must not be null.
		*   @return The distance between the given two points in 4D
		*   @throws TypeError If either 'pt1' or 'pt2' is null
		*/
		static public function distance4D(pt1:Vector3D, pt2:Vector3D): Number
		{
			// Compute the vector from pt1 to pt2
			var dX:Number = pt1.x - pt2.x;
			var dY:Number = pt1.y - pt2.y;
			var dZ:Number = pt1.z - pt2.z;
			var dW:Number = pt1.w - pt2.w;
 
			var dot:Number = dX*dX + dY*dY + dZ*dZ + dW*dW;
 
			// Distance is the magnitude or zero when the vectors are identical
			return dot > 0 ? Math.sqrt(dot) : 0;
		}
 
		/**
		*   Compute the dot product of this vector and another vector. This
		*   version includes the W component.
		*   @param a Vector to compute the dot product with. Must not be null.
		*   @return The dot product of this vector and 'a'
		*   @throws TypeError if 'a' is null
		*/
		public function dotProduct4D(a:Vector3D): Number
		{
			return x*a.x + y*a.y + z*a.z + w*a.w;
		}
 
		/**
		*   Add component-wise a given vector from this vector and store
		*   the result in a third vector. The W component of 'into' is copied
		*   from this vector without addition.
		*   @param a Vector to add to this vector. Must not be null.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function incrementByInto(a:Vector3D, into:Vector3D): void
		{
			into.x = x + a.x;
			into.y = y + a.y;
			into.z = z + a.z;
			into.w = w;
		}
 
		/**
		*   Add component-wise a given vector from this vector. This
		*   version includes the W component.
		*   @param a Vector to add to this vector. Must not be null.
		*   @throws TypeError If 'a' is null
		*/
		public function incrementBy4D(a:Vector3D): void
		{
			x += a.x;
			y += a.y;
			z += a.z;
			w += a.w;
		}
 
		/**
		*   Add component-wise a given vector from this vector and store
		*   the result in a third vector. This version includes the W component.
		*   @param a Vector to add to this vector. Must not be null.
		*   @throws TypeError If either 'a' or 'into' is null
		*/
		public function incrementBy4DInto(a:Vector3D, into:Vector3D): void
		{
			into.x = x + a.x;
			into.y = y + a.y;
			into.z = z + a.z;
			into.w = w + a.w;
		}
 
		/**
		*   Negate this vector and store the result in another vector. The
		*   W component is copied from this vector without negation.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If 'into' is null.
		*/
		public function negateInto(into:Vector3D): void
		{
			into.x = -x;
			into.y = -y;
			into.z = -z;
			into.w = w;
		}
 
		/**
		*   Negate this vector. This version includes the W component.
		*/
		public function negate4D(): void
		{
			x = -x;
			y = -y;
			z = -z;
			w = -w;
		}
 
		/**
		*   Negate this vector and store the result in another vector. This
		*   version includes the W component.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If 'into' is null
		*/
		public function negate4DInto(into:Vector3D): void
		{
			into.x = -x;
			into.y = -y;
			into.z = -z;
			into.w = -w;
		}
 
		/**
		*   Normalize this vector (such that its 3D magnitude/length is one) and
		*   store the result in another vector. If the X, Y, and W components
		*   are all zero, no modification is made. The W component is copied
		*   from this vector to 'into' without modification and is not
		*   considered when computing the magnitude/length of this vector for
		*   normalization of the X, Y, and Z components.
		*   @param into Vector to store the result in. Must not be null.
		*   @return The 3D magnitude/length of this vector before normalization
		*           or zero if the X, Y, and Z components were all zero. W is
		*           ignored when computing this value.
		*   @throws TypeError If 'into' is null
		*/
		public function normalizeInto(into:Vector3D): Number
		{
			var dot:Number = x*x + y*y + z*z;
			if (dot > 0)
			{
				var mag:Number = Math.sqrt(dot);
				into.x = x / mag;
				into.y = y / mag;
				into.z = z / mag;
				into.w = w;
				return mag;
			}
			return 0.0;
		}
		
		
		
		/**
		*   Clone vector and normalize
		*   @return cloned normalized (unit) vector
		*/
		public function unit(): Vector3D
		{
			var u:Vector3D = this.clone();
			u.normalize();
			return u;
		}
 
		/**
		*   Normalize this vector (such that it's 4D magnitude/length is one).
		*   If the X, Y, Z, and W components are all zero, no modification is
		*   made. This version includes the W component.
		*   @return The 4D magnitude of this vector before normalization or zero
		*           if the X, Y, Z, and W components were all zero
		*/
		public function normalize4D(): Number
		{
			var dot:Number = x*x + y*y + z*z + w*w;
			if (dot > 0)
			{
				var mag:Number = Math.sqrt(dot);
				x /= mag;
				y /= mag;
				z /= mag;
				w /= mag;
				return mag;
			}
			return 0.0;
		}
 
		/**
		*   Normalize this vector (such that it's 4D magnitude/length is one)
		*   and store the result in another vector. If the X, Y, Z, and W
		*   components are all zero, no modification is made to 'into'. This
		*   version includes the W component.
		*   @param into Vector to store the result in. Must not be null.
		*   @return The 4D magnitude of this vector before normalization or zero
		*           if the X, Y, Z, and W components were all zero
		*   @throws TypeError If 'into' is null
		*/
		public function normalize4DInto(into:Vector3D): Number
		{
			var dot:Number = x*x + y*y + z*z + w*w;
			if (dot > 0)
			{
				var mag:Number = Math.sqrt(dot);
				into.x = x / mag;
				into.y = y / mag;
				into.z = z / mag;
				into.w = w / mag;
				return mag;
			}
			return 0.0;
		}
 
		/**
		*   Divide component-wise this vector's components by this vector's W
		*   component and store the result in another vector. If this vector's
		*   W component is zero, the X, Y, and Z components set to 'into' will
		*   be Infinity. W is copied from this vector to 'into' without
		*   modification.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If 'into' is null
		*/
		public function projectInto(into:Vector3D): void
		{
			into.x = x / w;
			into.y = y / w;
			into.z = z / w;
			into.w = w;
		}
 
		/**
		*   Divide component-wise this vector's components by this vector's W
		*   component. If this vector's W component is zero, its X, Y, and Z
		*   components will be set to Infinity. The W component of this vector
		*   is always set to one.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If 'into' is null
		*/
		public function project4D(): void
		{
			x /= w;
			y /= w;
			z /= w;
			w = 1.0;
		}
 
		/**
		*   Divide component-wise this vector's components by this vector's W
		*   component and store the result in another vector. If this vector's
		*   W component is zero, the X, Y, and Z components set to 'into' will
		*   be Infinity. The W component of 'into' is always set to one.
		*   @param into Vector to store the result in. Must not be null.
		*   @throws TypeError If 'into' is null
		*/
		public function project4DInto(into:Vector3D): void
		{
			into.x = x / w;
			into.y = y / w;
			into.z = z / w;
			into.w = 1.0;
		}
 
		/**
		*   Multiply the X, Y, and Z components of this vector by a given
		*   value and store the result in another vector. The W component of
		*   this vector is copied without modification.
		*   @param s Value to multiply by
		*   @param into Vector to store the result in
		*   @throws TypeError If 'into' is null
		*/
		public function scaleByInto(s:Number, into:Vector3D): void
		{
			into.x = x * s;
			into.y = y * s;
			into.z = z * s;
			into.w = w;
		}
 
		/**
		*   Multiply the X, Y, and Z components of this vector by a given
		*   value
		*   @param s Value to multiply by
		*/
		public function scaleBy4D(s:Number): void
		{
			x *= s;
			y *= s;
			z *= s;
			w *= s;
		}
 
		/**
		*   Multiply the X, Y, Z, and W components of this vector by a given
		*   value and store the result in another vector
		*   @param s Value to multiply by
		*   @param into Vector to store the result in
		*   @throws TypeError If 'into' is null
		*/
		public function scaleBy4DInto(s:Number, into:Vector3D): void
		{
			into.x = x * s;
			into.y = y * s;
			into.z = z * s;
			into.w = w * s;
		}
 
		/**
		*   Set all four components of this vector
		*   @param xa X component of this vector
		*   @param ya Y component of this vector
		*   @param za Z component of this vector
		*   @param wa W component of this vector
		*/
		public function setTo4D(xa:Number, ya:Number, za:Number, wa:Number): void
		{
			x = xa;
			y = ya;
			z = za;
			w = wa;
		}
 
		/**
		*   This version return a Vector3DExt
		*   @inheritDoc
		*/
		override public function subtract(a:Vector3D): Vector3D
		{
			return new Vector3DExt(
				x - a.x,
				y - a.y,
				z - a.z,
				0.0
			);
		}
 
		/**
		*   Subtract a vector component-wise from this vector and return a new
		*   vector. This version includes the W component. The original vector
		*   is not modified.
		*   @param a Vector to subtract from this vector. Must not be null.
		*   @return A new vector whose components are the difference between
		*           this vector and the given vector
		*   @throws TypeError If 'a' is null
		*/
		public function subtract4D(a:Vector3D): Vector3DExt
		{
			return new Vector3DExt(
				x - a.x,
				y - a.y,
				z - a.z,
				w - a.w
			);
		}
		
		
	        


    
   
   

    // ______________________________________________________________________

    
    /**
     * scalar projection
	 * 
	 * length of projection of vector a on vector b
	 * return |a| * cosQ
	 * 
     *                           a · b
                    proj b a = -------   = a·ub

                                ||b||   
     */
    public function sproj(b:Vector3D):Number
    {
        //return Number3D.dot(v, Number3D.unit(w));
		var unit:Vector3D = b.clone();
		unit.normalize();
		
		return this.dotProduct(unit);
    }
    
    /**
     * vector projection
	 * 
	 * vector created by projection of vector a on vector b
     *                   _ _    a · b
                    proj b a = -------  · ub = a · ub · ub=proj b a * ub

                                ||b|| 
     */
    public function vproj(b:Vector3D):Vector3D
    {
       // var mod:Number = Number3D.sproj(v, w);
       // return Number3D.mul(mod,Number3D.unit(w) );
	   var unit:Vector3D = b.clone();
	   unit.normalize();//make normalize
	   return unit.scaleBy(this.dotProduct(unit));
        
	   
    }
    
    
    
    /**
     * scalar projection perpendicular  
	 * 
	 * @return length of normal to projection of vector "a" to vector "b"
     * 
                                  ____________________

                    perp b a = \/ ||a||2 + (proj b a)2
    */
    public function sperp(b:Vector3D):Number
    {    
        //return Math.sqrt(v.modulo * v.modulo + Math.pow(Number3D.sproj(v, w), 2));
		//Pithagora
		
    }
    
    
    /**
     * vector perpendicular 
	 * 
	 *  * @return vector normal to projection of vector "a" to vector "b"
	 * 
     *                                           -      -
                                            proj b  a - a
                         - -       
                    perp b a = perp b a * ----------------

                                            ||proj b a - a||
                                            
                                            
    */
    public function vperp(b:Vector3D):Vector3D
    {    
       // var mod:Number = Number3D.sperp(v, w);
        
       // return Number3D.mul(mod,Number3D.unit(Number3D.sub(Number3D.vproj(v, w), w)));
	   return ;
    }  
 
		/**
		*   Get a string representation of this vector. This version includes
		*   the W component.
		*   @return A string representation of this vector including the W
		*           component
		*/
		public function toString4D(): String
		{
			return "Vector3DExt("
				+ x + ", "
				+ y + ", "
				+ z + ", "
				+ w
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version does NOT
		*   include the W component. All components of the vector are formatted
		*   using Number.toExponential().
		*   @param fractionDigits An integer between 0 and 20, inclusive, that
		*                         represents the desired number of decimal
		*                         places.
		*   @return A string representation of this vector NOT including the W
		*           component
		*   @throws RangeError If the fractionDigits argument is outside the
		*                      range 0 to 20.
		*/
		public function toStringExponential(fractionDigits:uint): String
		{
			return "Vector3DExt("
				+ x.toExponential(fractionDigits) + ", "
				+ y.toExponential(fractionDigits) + ", "
				+ z.toExponential(fractionDigits)
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version includes
		*   the W component. All components of the vector are formatted using
		*   Number.toExponential().
		*   @param fractionDigits An integer between 0 and 20, inclusive, that
		*                         represents the desired number of decimal
		*                         places.
		*   @return A string representation of this vector including the W
		*           component
		*   @throws RangeError If the fractionDigits argument is outside the
		*                      range 0 to 20.
		*/
		public function toString4DExponential(fractionDigits:uint): String
		{
			return "Vector3DExt("
				+ x.toExponential(fractionDigits) + ", "
				+ y.toExponential(fractionDigits) + ", "
				+ z.toExponential(fractionDigits) + ", "
				+ w.toExponential(fractionDigits)
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version does NOT
		*   include the W component. All components of the vector are formatted
		*   using Number.toFixed().
		*   @param fractionDigits An integer between 0 and 20, inclusive, that
		*                         represents the desired number of decimal
		*                         places.
		*   @return A string representation of this vector NOT including the W
		*           component
		*   @throws RangeError If the fractionDigits argument is outside the
		*                      range 0 to 20.
		*/
		public function toStringFixed(fractionDigits:uint): String
		{
			return "Vector3DExt("
				+ x.toFixed(fractionDigits) + ", "
				+ y.toFixed(fractionDigits) + ", "
				+ z.toFixed(fractionDigits)
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version includes
		*   the W component. All components of the vector are formatted using
		*   Number.toFixed().
		*   @param fractionDigits An integer between 0 and 20, inclusive, that
		*                         represents the desired number of decimal
		*                         places.
		*   @return A string representation of this vector including the W
		*           component
		*   @throws RangeError If the fractionDigits argument is outside the
		*                      range 0 to 20.
		*/
		public function toString4DFixed(fractionDigits:uint): String
		{
			return "Vector3DExt("
				+ x.toFixed(fractionDigits) + ", "
				+ y.toFixed(fractionDigits) + ", "
				+ z.toFixed(fractionDigits) + ", "
				+ w.toFixed(fractionDigits)
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version does NOT
		*   include the W component. All components of the vector are formatted
		*   using Number.toPrecision().
		*   @param precision An integer between 1 and 21, inclusive, that
		*                    represents the desired number of digits to
		*                    represent in the resulting string.
		*   @return A string representation of this vector NOT including the W
		*           component
		*   @throws RangeError If the precision argument is outside the range 1
		*                      to 21.
		*/
		public function toStringPrecision(precision:uint): String
		{
			return "Vector3DExt("
				+ x.toPrecision(precision) + ", "
				+ y.toPrecision(precision) + ", "
				+ z.toPrecision(precision)
				+ ")";
		}
 
		/**
		*   Get a string representation of this vector. This version includes
		*   the W component. All components of the vector are formatted
		*   using Number.toPrecision().
		*   @param precision An integer between 1 and 21, inclusive, that
		*                    represents the desired number of digits to
		*                    represent in the resulting string.
		*   @return A string representation of this vector including the W
		*           component
		*   @throws RangeError If the precision argument is outside the range 1
		*                      to 21.
		*/
		public function toString4DPrecision(precision:uint): String
		{
			return "Vector3DExt("
				+ x.toPrecision(precision) + ", "
				+ y.toPrecision(precision) + ", "
				+ z.toPrecision(precision) + ", "
				+ w.toPrecision(precision)
				+ ")";
		}
	}
}