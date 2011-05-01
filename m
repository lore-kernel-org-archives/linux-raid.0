From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sun, 01 May 2011 20:32:22 +0200
Message-ID: <ipk8vn$s9a$1@dough.gmane.org>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>	<20110501082717.5116e575@notabene.brown> <19901.31958.368144.832086@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19901.31958.368144.832086@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On 01/05/11 17:31, Peter Grandi wrote:
> [ ... ]
>
>>> * Can Linux MD do "abbreviated" read-modify-write RAID6
>>> updates like for RAID5? [ ... ]
>
>> No. (patches welcome).
>
> Ahhhm, but let me dig a bit deeper, even if it may be implied in
> the answer: would it be *possible*?
>
> That is, is the double parity scheme used in MS such that it is
> possible to "subtract" the old content of a page and "add" the
> new content of that page to both parity pages?
>

If I've understood the maths correctly, then yes it would be possible.=20
But it would involve more calculations, and it is difficult to see wher=
e=20
the best balance lies between cpu demands and IO demands.  In general,=20
calculating the Q parity block for raid6 is processor-intensive -=20
there's a fair amount of optimisation done in the normal calculations t=
o=20
keep it reasonable.

Basically, the first parity P is a simple calculation:

P =3D D_0 + D_1 + .. + D_n-1

But Q is more difficult:

Q =3D D_0 + g.D_1 + g=B2.D_2 + ... + g^(n-1).D_n-1

where "plus" is xor, "times" is a weird function calculated over a=20
G(2^8) field, and g is a generator for that field.

If you want to replace D_i, then you can calculate:

P(new) =3D P(old) + D_i(old) + D_i(new)

Q(new) =3D Q(old) + g^i.(D_i(old) + D_i(new))

This means multiplying by g_i for whichever block i is being replaced.

The generator and multiply operation are picked to make it relatively=20
fast and easy to multiply by g, especially if you've got a processor=20
that has vector operations (as most powerful cpus do).  This means that=
=20
the original Q calculation is fairly efficient.  But to do general=20
multiplications by g_i is more effort, and will typically involve=20
cache-killing lookup tables or multiple steps.


It is probably reasonable to say that when md raid first implemented=20
raid6, it made little sense to do these abbreviated parity calculations=
=2E=20
  But as processors have got faster (and wider, with more cores) while=20
disk throughput has made slower progress, it's maybe a different=20
balance.  So it's probably both possible and practical to do these=20
calculations.  All it needs is someone to spend the time writing the=20
code - and lots of people willing to test it.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
