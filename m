From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 15:18:01 +0200
Message-ID: <20110611131801.GA2764@lazy.lzy>
References: <isp2g2$rf$1@dough.gmane.org>
 <20110609114954.243e9e22@notabene.brown>
 <isqb2o$g0s$1@dough.gmane.org>
 <20110609220438.26336b27@notabene.brown>
 <87aadq5q1l.fsf@gmail.com>
 <isslla$o2i$1@dough.gmane.org>
 <4DF20C18.3030604@christoph-d.de>
 <ist9n7$khq$1@dough.gmane.org>
 <20110611101312.GA3528@lazy.lzy>
 <isvkrg$c79$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <isvkrg$c79$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 11, 2011 at 01:51:12PM +0200, David Brown wrote:
> On 11/06/11 12:13, Piergiorgio Sartor wrote:
> >[snip]
> >>Of course, all this assume that my maths is correct !
> >
> >I would suggest to check out the Reed-Solomon thing
> >in the more friendly form of Vandermonde matrix.
> >
> >It will be completely clear how to generate k parity
> >set with n data set (disk), so that n+k<  258 for the
> >GF(256) space.
> >
> >It will also be much more clear how to re-construct
> >the data set in case of erasure (known data lost).
> >
> >You can have a look, for reference, at:
> >
> >http://lsirwww.epfl.ch/wdas2004/Presentations/manasse.ppt
> >
> >If you search for something like "Reed Solomon Vandermonde"
> >you'll find even more information.
> >
> >Hope this helps.
> >
> >bye,
> >
> 
> That presentation is using Vandermonde matrices, which are the same
> as the ones used in James Plank's papers.  As far as I can see,
> these are limited in how well you can recover from missing disks
> (the presentation here says it only works for up to triple parity).

As far as I understood, 3 is only an example, it works
up to k lost disks, with n+k < 258 (or 259).
I mean, I do not see why it should not.

You've, of course, to know which disks are failed.
On the other hand, having k parities allows you to find
up to k/2 error positions.
This is bit more complicated, I guess.
You can search for Berlekamp-Massey Algorithm (and related)
in order to see how to *find* the errors.

> They Vandermonde matrices have that advantage that the determinants
> are easily calculated - I haven't yet figured out an analytical
> method of calculating the determinants in my equations, and have
> just used brute force checking. (My syndromes also have the
> advantage of being easy to calculate quickly.)

I think the point of Reed Solomon (with Vandermonde or Cauchy
matrices) is also that it generalize the parity concept.

This means you do not have to care if it is 2 or 3 or 7 or ...

In this way you can have as many parities as you like, up to
the limitation of Reed Solomon in GF(256).

> Still, I think the next step for me should be to write up the maths
> a bit more formally, rather than just hints in mailing list posts.
> Then others can have a look, and have an opinion on whether I've got
> it right or not.  It makes sense to be sure the algorithms will work
> before spending much time implementing them!

I tend to agree. At first you should set up the background
theory, then the algorithm, later the implementation and
eventually the optimization.
 
> I certainly /believe/ my maths is correct here - but it's nearly
> twenty years since I did much formal algebra.  I studied maths at
> university, but I don't use group theory often in my daily job as an
> embedded programmer.

Well, I, for sure, will stay tuned for your results!

bye,

-- 

piergiorgio
