From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 13:51:12 +0200
Message-ID: <isvkrg$c79$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110611101312.GA3528@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/11 12:13, Piergiorgio Sartor wrote:
> [snip]
>> Of course, all this assume that my maths is correct !
>
> I would suggest to check out the Reed-Solomon thing
> in the more friendly form of Vandermonde matrix.
>
> It will be completely clear how to generate k parity
> set with n data set (disk), so that n+k<  258 for the
> GF(256) space.
>
> It will also be much more clear how to re-construct
> the data set in case of erasure (known data lost).
>
> You can have a look, for reference, at:
>
> http://lsirwww.epfl.ch/wdas2004/Presentations/manasse.ppt
>
> If you search for something like "Reed Solomon Vandermonde"
> you'll find even more information.
>
> Hope this helps.
>
> bye,
>

That presentation is using Vandermonde matrices, which are the same as 
the ones used in James Plank's papers.  As far as I can see, these are 
limited in how well you can recover from missing disks (the presentation 
here says it only works for up to triple parity).  They Vandermonde 
matrices have that advantage that the determinants are easily calculated 
- I haven't yet figured out an analytical method of calculating the 
determinants in my equations, and have just used brute force checking. 
(My syndromes also have the advantage of being easy to calculate quickly.)


Still, I think the next step for me should be to write up the maths a 
bit more formally, rather than just hints in mailing list posts.  Then 
others can have a look, and have an opinion on whether I've got it right 
or not.  It makes sense to be sure the algorithms will work before 
spending much time implementing them!

I certainly /believe/ my maths is correct here - but it's nearly twenty 
years since I did much formal algebra.  I studied maths at university, 
but I don't use group theory often in my daily job as an embedded 
programmer.


