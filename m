From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 16:53:38 +0200
Message-ID: <isvvhi$2vf$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy> <isvkrg$c79$1@dough.gmane.org> <20110611131801.GA2764@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110611131801.GA2764@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/11 15:18, Piergiorgio Sartor wrote:
> On Sat, Jun 11, 2011 at 01:51:12PM +0200, David Brown wrote:
>> On 11/06/11 12:13, Piergiorgio Sartor wrote:
>>> [snip]
>>>> Of course, all this assume that my maths is correct !
>>>
>>> I would suggest to check out the Reed-Solomon thing
>>> in the more friendly form of Vandermonde matrix.
>>>
>>> It will be completely clear how to generate k parity
>>> set with n data set (disk), so that n+k<   258 for the
>>> GF(256) space.
>>>
>>> It will also be much more clear how to re-construct
>>> the data set in case of erasure (known data lost).
>>>
>>> You can have a look, for reference, at:
>>>
>>> http://lsirwww.epfl.ch/wdas2004/Presentations/manasse.ppt
>>>
>>> If you search for something like "Reed Solomon Vandermonde"
>>> you'll find even more information.
>>>
>>> Hope this helps.
>>>
>>> bye,
>>>
>>
>> That presentation is using Vandermonde matrices, which are the same
>> as the ones used in James Plank's papers.  As far as I can see,
>> these are limited in how well you can recover from missing disks
>> (the presentation here says it only works for up to triple parity).
>
> As far as I understood, 3 is only an example, it works
> up to k lost disks, with n+k<  258 (or 259).
> I mean, I do not see why it should not.
>

I also don't see why 3 parity should be a limitation - I think it must 
be because of the choice of syndrome calculations.  But the presentation 
you linked to specifically says on page 3 that it will say "Why it stops 
at three erasures, and works only for GF(2^k)".  I haven't investigated 
anything other than GF(2^8), since that is optimal for implementing raid 
(well, 2^1 is easier - but that only gives you raid5).  Unfortunately, 
the paper doesn't give details there.  Adam Leventhal's blog (mentioned 
earlier in this thread) also says that implementation of triple-parity 
for ZFS was relatively easy, but not for more than three parity bits.

> You've, of course, to know which disks are failed.

That's normally the case for disk applications.

> On the other hand, having k parities allows you to find
> up to k/2 error positions.
> This is bit more complicated, I guess.
> You can search for Berlekamp-Massey Algorithm (and related)
> in order to see how to *find* the errors.
>

I've worked with ECC systems for data transmission and communications 
systems, when you don't know if there are any errors or where the errors 
might be.  But although there is a fair overlap of the theory here, 
there are big differences in the way you implement such checking and 
correction, and your priorities.  With raid, you know either that your 
block read is correct (because of the ECC handled at the drive firmware 
level), or incorrect.

To deal with unknown errors or error positions, you have to read in 
everything in a stripe and run your error checking for every read - that 
would be a significant run-time cost, which normally be wasted (as the 
raid set is normally consistent).

One situation where that might be useful, however, is for scrubbing or 
checking when the array is know to be inconsistent (such as after a 
power failure).  Neil has already argued that the simple approach of 
re-creating the parity blocks (rather than identifying incorrect blocks) 
is better, or at least no worse, than being "smart".  But the balance of 
that argument might change with more parity blocks.

<http://neil.brown.name/blog/20100211050355>

>> They Vandermonde matrices have that advantage that the determinants
>> are easily calculated - I haven't yet figured out an analytical
>> method of calculating the determinants in my equations, and have
>> just used brute force checking. (My syndromes also have the
>> advantage of being easy to calculate quickly.)
>
> I think the point of Reed Solomon (with Vandermonde or Cauchy
> matrices) is also that it generalize the parity concept.
>
> This means you do not have to care if it is 2 or 3 or 7 or ...
>
> In this way you can have as many parities as you like, up to
> the limitation of Reed Solomon in GF(256).
>

I agree.  However, I'm not sure there is much practical use of going 
beyond perhaps 4 parity blocks - at that stage you are probably better 
dividing up your array, or (if you need more protection) using n-parity 
raid6 over raid1 mirror sets.

>> Still, I think the next step for me should be to write up the maths
>> a bit more formally, rather than just hints in mailing list posts.
>> Then others can have a look, and have an opinion on whether I've got
>> it right or not.  It makes sense to be sure the algorithms will work
>> before spending much time implementing them!
>
> I tend to agree. At first you should set up the background
> theory, then the algorithm, later the implementation and
> eventually the optimization.
>

Yes - we've already established that the implementation will be 
possible, and that there are people willing and able to help with it. 
And I believe that much of the optimisation can be handled by the 
compiler - gcc has come a long way since raid6 was first implemented in 
mdraid.

>> I certainly /believe/ my maths is correct here - but it's nearly
>> twenty years since I did much formal algebra.  I studied maths at
>> university, but I don't use group theory often in my daily job as an
>> embedded programmer.
>
> Well, I, for sure, will stay tuned for your results!
>
> bye,
>


