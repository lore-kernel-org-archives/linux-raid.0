From: David Brown <david@westcontrol.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Tue, 17 Apr 2012 09:58:05 +0200
Message-ID: <4F8D228D.8060005@westcontrol.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alex,

I've been playing around with triple-parity raid theory for a while. 
It's been mainly for my own interest - it's fun to do some deeper maths 
(I studied maths at university, but this is the first time I've done 
serious group theory in the last 20 years), fun to resurrect my LaTeX 
skills, and maybe it will be useful to the md raid developers.

My current state is that I've got theory worked out and written up - not 
just for triple parity, but for more parities as well.  For some of it, 
I've got Python code to test and verify the maths.  It turns out that 
triple parity can work well - but for quad parity the limit is 21 data 
disks (using generators 2, 4, and 8), or up to 33 (using for example 
0x07, 0x35 and 0x8b as generators).  Realistically, I think triple 
parity is the limit for practical implementations.

I haven't finished the paper - in particular, I haven't filled out the 
simplifications of the triple parity work from more general matrix 
forms.  I also hope to work on implementation details for the 
calculations.  But maybe there is already enough to be of interest to 
some people, such as yourself.

<http://redhouse.homelinux.net/raid/>

mvh.,

David



On 17/04/2012 08:11, Alex wrote:
> Thanks to Billy Crook who pointed out this is the right place for my post.
>
> Adam Leventhal integrated triple-parity RAID into ZFS in 2009. The
> necessity of triple-parity RAID is described in detail in Adam
> Leventhal's article(http://cacm.acm.org/magazines/2010/1/55741-triple-parity-raid-and-beyond/fulltext).
> Basically it is because hard drive capacity has doubled
> annually(Kryder's law) while hard drive throughput has improved far
> more modestly, the time it takes to recover a faulty hard disk in a
> double-parity RAID like RAID 6 might become so long(in 2010, it takes
> about 4 hours to recover a 1TB SAS hard disk at its full speed) that
> the remaining array(essentially a RAID 5 array, which has proven to be
> unsafe) might fail and cause data loss during recovery. Earlier this
> year, Ostler et
> al.(http://www.nature.com/ncomms/journal/v3/n2/full/ncomms1666.html)
> established a revolutionary way of writing magnetic substrate using a
> heat pulse instead of a traditional magnetic field, which may increase
> data throughput on a hard disk by 1000 times in the future. They
> estimated the commercial usage of this new technology would be advent
> in about 10 years. That said, within the next 10 years, having
> triple-parity RAID in a data integrity demanding environment is still
> highly desirable.
>
> Unfortunately, due to conflicts between CDDL license of Oracle and GNU
> license of Linux, ZFS and hence triple-parity RAID cannot be ported to
> Linux. As a die-hard follower of the open source community, I am NOT
> exactly pleased by this kind of drama. But instead of claiming the
> grape to be sour, I decided to grow my own.
>
> The work I am going to present here builds on top of that of Adam
> Leventhal(http://src.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/fs/zfs/vdev_raidz.c)
> and Peter Anvin(http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf).
> I will generalize Adam Leventhal's work using Peter Anvin's method,
> then pick another generator from the Galois field GF(2^8) to
> facilitate another triple-parity RAID algorithm that hopefully can be
> used by the part of open source community that is not CDDL compliant
> and beyond. System engineers who are not exactly familiar with Galois
> field theory may find themselves a great exposure for that in Peter
> Anvin's article.
>
> I will use the same notation as in Adam Leventhal's work: D_0, ...
> D_n-1 represents corresponding bytes in the n data disks in the array,
> addition + is bitwise XOR, multiplication * is multiplication in
> GF(2^8), multiplication in the power(for example,2(n-1) in  g^2(n-1)
> below) on the other hand, is multiplication in modulo ring Z_255.
>
> (1) P = D_0 + D_1 + ... + D_n-2 + D_n-1
> (2) Q = g^n-1 * D_0 + g^n-2 * D_1 + ... + g^1 * D_n-2 + D_n-1
>        = ((...((D_0) * g + D_1) * g + ...) * g + D_n-2) * g + D_n-1
> (3) R = g^2(n-1) * D_0 + g^2(n-2) * D_1 + ... + g^2 * D_n-2 + D_n-1
>        = ((...((D_0) * g^2 + D_1) * g^2 + ...) * g^2 + D_n-2) * g^2 + D_n-1
>
> P,Q,R are the definitions of the parity bytes, these are usually
> called P,Q,R syndromes in the literature. Adam Leventhal used
> generator {02} in the cyclic representation of Galois field GF(2^8), I
> instead use an arbitrary generator g in the definition of P,Q and R.
> For generator g, g^k is a generator if and only if k is relatively
> prime to 255. Since g^255 = 1, g^(-1) = g^254 is a generator for 254
> is relatively prime to 255. g^(-1) is the generator I am going to use
> to optimize my triple-parity RAID algorithm.
>
> Now let's prove we can always recover from 3 or less disk failures,
> namely, we can always solve (1), (2), (3) for a unique solution if 3
> or less of {P, Q, R, D_0, ... D_n-1} are unknowns.
>
> We start with the most difficult case, i.e., 3 of {D_0, ... D_n-1} are
> unknowns, or 3 data disks have failed and let's call them D_x, D_y and
> D_z. For (1), we move the constants on the right to the left and
> combine them with P and call the sum to be P_xyz, so (1) becomes
>
> (1)' P_xyz = D_x + D_y + D_z
>
> Similarly, (2) and (3) become
>
> (2)' Q_xyz = g^x * D_x + g^y * D_y + g^z * D_z
> (3)' R_xyz = g^2x * D_x + g^2y * D_y + g^2z * D_z
>
>  From (1)', we have D_z = P_xyz + D_x + D_y since A + A = 0 in a Galois
> field. Substitute this into (2)' and (3)', and move the constants to
> the left and call them Q_xyz' and R_xyz', we got
>
> (2)'' Q_xyz' = (g^x + g^z) * D_x + (g^y + g^z) * D_y
> (3)'' R_xyz' = (g^2x + g^2z) * D_x + (g^2y + g^2z) * D_y
>
> Here comes the trick, multiply (2)'' by g^y + g^z, the coefficient for
> D_y becomes (g^y + g^z) * (g^y + g^z) = g^2y + g^y * g^z + g^z * g^y +
> g^2z = g^2y + g^2z(A + A = 0 again), then add it to (3)'' and move the
> constants to the left and call it R_xyz'', we have
>
> (3)''' R_xyz'' = [(g^x + g^z) * (g^y + g^z) + g^2x + g^2z] * D_x
>                 = [g^(x+y) + g^(x+z) + g^(z+y) + g^2z + g^2x +g^2z] * D_x
>                 = [g^(x+y) + g^(x+z) + g^(z+y) + g^2x] * D_x (A + A = 0 again)
>                 = [g^y * (g^x + g^z) + g^x *(g^x + g^z)] * D_x
>                 = (g^y + g^x) * (g^x + g^z) * D_x
>
> Now because x, y, z are distinct integers, if we assume 0<= x, y, z<
> n<= 255, then neither g^y + g^x nor g^x + g^z can be zero since g is
> a generator and we can solve for D_x from (3)'''. A similar argument
> can be applied to D_y's coefficient in (2)'' to solve for D_y and from
> (1)' we can solve for D_z.
>
> In a failure of 3 disks involving 1 or more parity disks, we may use
> the equations not involving a failed data disk to uniquely solve for
> unknows representing the failed data disk bytes, then use the rest of
> the equations to recalculate the failed parity disk bytes.
>
> In a failure involving only two data disks, we may use an argument
> similar to above and two of the three equations to uniquely solve for
> the unknowns(you might need to observe that g^2 is also a generator
> since 2 is relatively prime to 255), the only question is: does the
> solution satisfy the third equation? The answer is it has to. The
> reason is we originally(before the two data disks failed) have a
> solution for the two unknowns that satisfies all three equations,
> hence also satisfies the two we used to solve for the unknowns; but
> now we uniquely solve for the unknowns from those two equations, so
> they have to be the original values.
>
> The arguments for other cases are similar, but only easier.
>
> There is an important observation here: The Gauss-Jordan elimination
> in the proof above can be apply to Adam Leventhal's code although one
> has 3 equations, the other has n+3. And this observaton has two
> implications:
>
> 1) If we replace g with generator {02} in GF(2^8), we have proven that
> the algorithm used in Adam Leventhal's code is sound.(I am sure Adam
> Leventhal has his own proof, but as another guy with a math
> background, I am not convinced until I see it.)
>
> 2) For other generators in GF(2^8), we can use the same procedure in
> the algorithm of Adam Leventhal's code once the corresponding
> logarithm and powers tables are replaced, this enable us to reuse most
> of the code in Adam Leventhal's code.
>
> So much for the math, now we enter neverland of a system enggineer.
> Let's consider GF(2^8)'s another generator {02}^(-1) and try to
> optimize the calculation for the Q ad R syndromes. For this purpose,
> we use the second equality in (2) and (3). The addition is just
> bitewise XOR, what we need to optimize is the multiplication by
> {02}^(-1). Following the way in Peter Anvin's article, we found that
> multiplication is implemented by the following bitwise operations:
>
> (x * {02}^(-1))_7 = x_0
> (x * {02}^(-1))_6 = x_7
> (x * {02}^(-1))_5 = x_6
> (x * {02}^(-1))_4 = x_5
> (x * {02}^(-1))_3 = x_4 + x_0
> (x * {02}^(-1))_2 = x_3 + x_0
> (x * {02}^(-1))_1 = x_2 + x_0
> (x * {02}^(-1))_0 = x_1
>
> For 32 bit architecture, the C code optimizing it is as follows:
>
> uint32_t v vv;
> vv = (v>>  1)&  0x7f7f7f7f;
> vv ^= MASK(v)&  0x8e8e8e8e;
>
> uint32_t MASK(uint32_t v)
> {
>    v&= 0x01010101;
>    return (v<<  8) - v;
> }
>
> The code for 64 bit architecture is just a simple extension of this,
> or you may consult  Adam Leventhal's code.
>
> For arbitrary multiplication in the Gauss-Jordan elimination of the
> recovery process, we use the rule:
>
> A * B = C<==>  C = g^(log_g A + log_g B)
> A / B = C<==>  C = g^(log_g A - log_g B)
>
> where log_g is the discrete logarithm and g = {02}^(-1).
>
> And the tables for discrete logarithm and powers of {02}^(-1) is as follows:
>
> Powers table:
>
> 0x01, 0x8e, 0x47, 0xad, 0xd8, 0x6c, 0x36, 0x1b,
> 0x83, 0xcf, 0xe9, 0xfa, 0x7d, 0xb0, 0x58, 0x2c,
> 0x16, 0x0b, 0x8b, 0xcb, 0xeb, 0xfb, 0xf3, 0xf7,
> 0xf5, 0xf4, 0x7a, 0x3d, 0x90, 0x48, 0x24, 0x12,
> 0x09, 0x8a, 0x45, 0xac, 0x56, 0x2b, 0x9b, 0xc3,
> 0xef, 0xf9, 0xf2, 0x79, 0xb2, 0x59, 0xa2, 0x51,
> 0xa6, 0x53, 0xa7, 0xdd, 0xe0, 0x70, 0x38, 0x1c,
> 0x0e, 0x07, 0x8d, 0xc8, 0x64, 0x32, 0x19, 0x82,
> 0x41, 0xae, 0x57, 0xa5, 0xdc, 0x6e, 0x37, 0x95,
> 0xc4, 0x62, 0x31, 0x96, 0x4b, 0xab, 0xdb, 0xe3,
> 0xff, 0xf1, 0xf6, 0x7b, 0xb3, 0xd7, 0xe5, 0xfc,
> 0x7e, 0x3f, 0x91, 0xc6, 0x63, 0xbf, 0xd1, 0xe6,
> 0x73, 0xb7, 0xd5, 0xe4, 0x72, 0x39, 0x92, 0x49,
> 0xaa, 0x55, 0xa4, 0x52, 0x29, 0x9a, 0x4d, 0xa8,
> 0x54, 0x2a, 0x15, 0x84, 0x42, 0x21, 0x9e, 0x4f,
> 0xa9, 0xda, 0x6d, 0xb8, 0x5c, 0x2e, 0x17, 0x85,
> 0xcc, 0x66, 0x33, 0x97, 0xc5, 0xec, 0x76, 0x3b,
> 0x93, 0xc7, 0xed, 0xf8, 0x7c, 0x3e, 0x1f, 0x81,
> 0xce, 0x67, 0xbd, 0xd0, 0x68, 0x34, 0x1a, 0x0d,
> 0x88, 0x44, 0x22, 0x11, 0x86, 0x43, 0xaf, 0xd9,
> 0xe2, 0x71, 0xb6, 0x5b, 0xa3, 0xdf, 0xe1, 0xfe,
> 0x7f, 0xb1, 0xd6, 0x6b, 0xbb, 0xd3, 0xe7, 0xfd,
> 0xf0, 0x78, 0x3c, 0x1e, 0x0f, 0x89, 0xca, 0x65,
> 0xbc, 0x5e, 0x2f, 0x99, 0xc2, 0x61, 0xbe, 0x5f,
> 0xa1, 0xde, 0x6f, 0xb9, 0xd2, 0x69, 0xba, 0x5d,
> 0xa0, 0x50, 0x28, 0x14, 0x0a, 0x05, 0x8c, 0x46,
> 0x23, 0x9f, 0xc1, 0xee, 0x77, 0xb5, 0xd4, 0x6a,
> 0x35, 0x94, 0x4a, 0x25, 0x9c, 0x4e, 0x27, 0x9d,
> 0xc0, 0x60, 0x30, 0x18, 0x0c, 0x06, 0x03, 0x8f,
> 0xc9, 0xea, 0x75, 0xb4, 0x5a, 0x2d, 0x98, 0x4c,
> 0x26, 0x13, 0x87, 0xcd, 0xe8, 0x74, 0x3a, 0x1d,
> 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
>
> Log table:
>
> 0x00, 0x00, 0xfe, 0xe6, 0xfd, 0xcd, 0xe5, 0x39,
> 0xfc, 0x20, 0xcc, 0x11, 0xe4, 0x97, 0x38, 0xb4,
> 0xfb, 0x9b, 0x1f, 0xf1, 0xcb, 0x72, 0x10, 0x7e,
> 0xe3, 0x3e, 0x96, 0x07, 0x37, 0xf7, 0xb3, 0x8e,
> 0xfa, 0x75, 0x9a, 0xd0, 0x1e, 0xdb, 0xf0, 0xde,
> 0xca, 0x6c, 0x71, 0x25, 0x0f, 0xed, 0x7d, 0xba,
> 0xe2, 0x4a, 0x3d, 0x82, 0x95, 0xd8, 0x06, 0x46,
> 0x36, 0x65, 0xf6, 0x87, 0xb2, 0x1b, 0x8d, 0x59,
> 0xf9, 0x40, 0x74, 0x9d, 0x99, 0x22, 0xcf, 0x02,
> 0x1d, 0x67, 0xda, 0x4c, 0xef, 0x6e, 0xdd, 0x77,
> 0xc9, 0x2f, 0x6b, 0x31, 0x70, 0x69, 0x24, 0x42,
> 0x0e, 0x2d, 0xec, 0xa3, 0x7c, 0xc7, 0xb9, 0xbf,
> 0xe1, 0xbd, 0x49, 0x5c, 0x3c, 0xb7, 0x81, 0x91,
> 0x94, 0xc5, 0xd7, 0xab, 0x05, 0x7a, 0x45, 0xc2,
> 0x35, 0xa1, 0x64, 0x60, 0xf5, 0xea, 0x86, 0xd4,
> 0xb1, 0x2b, 0x1a, 0x53, 0x8c, 0x0c, 0x58, 0xa8,
> 0xf8, 0x8f, 0x3f, 0x08, 0x73, 0x7f, 0x9c, 0xf2,
> 0x98, 0xb5, 0x21, 0x12, 0xce, 0x3a, 0x01, 0xe7,
> 0x1c, 0x5a, 0x66, 0x88, 0xd9, 0x47, 0x4b, 0x83,
> 0xee, 0xbb, 0x6d, 0x26, 0xdc, 0xdf, 0x76, 0xd1,
> 0xc8, 0xc0, 0x2e, 0xa4, 0x6a, 0x43, 0x30, 0x32,
> 0x6f, 0x78, 0x68, 0x4d, 0x23, 0x03, 0x41, 0x9e,
> 0x0d, 0xa9, 0x2c, 0x54, 0xeb, 0xd5, 0xa2, 0x61,
> 0x7b, 0xc3, 0xc6, 0xac, 0xb8, 0x92, 0xbe, 0x5d,
> 0xe0, 0xd2, 0xbc, 0x27, 0x48, 0x84, 0x5b, 0x89,
> 0x3b, 0xe8, 0xb6, 0x13, 0x80, 0xf3, 0x90, 0x09,
> 0x93, 0x5e, 0xc4, 0xad, 0xd6, 0x62, 0xaa, 0x55,
> 0x04, 0x9f, 0x79, 0x4e, 0x44, 0x33, 0xc1, 0xa5,
> 0x34, 0xa6, 0xa0, 0x4f, 0x63, 0x56, 0x5f, 0xae,
> 0xf4, 0x0a, 0xe9, 0x14, 0x85, 0x8a, 0xd3, 0x28,
> 0xb0, 0x51, 0x2a, 0x16, 0x19, 0x18, 0x52, 0x17,
> 0x8b, 0x29, 0x0b, 0x15, 0x57, 0xaf, 0xa7, 0x50
>
> The originally purpose of this work is to enable Linux to have
> triple-parity RAID, but I guess it is all right for the rest of the
> open source community to use it too. If you are not sure about your
> situation or you'd rather talk to me in private about other issues,
> please contact me at: creamyfish@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


