From: David Brown <david@westcontrol.com>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 16:28:09 +0200
Message-ID: <ist9n7$khq$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org>	<20110609114954.243e9e22@notabene.brown>	<isqb2o$g0s$1@dough.gmane.org>	<20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF20C18.3030604@christoph-d.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2011 14:20, Christoph Dittmann wrote:
> On 06/10/2011 10:45 AM, David Brown wrote:
>> Making multiple parity syndromes is easy enough mathematically:
>
> Adam Leventhal, who wrote the double parity and triple parity code for
> ZFS, mentioned on his blog [1] that going beyond triple parity poses
> significant challenges if write performance should not suffer.
>
> In particular, it looks like a relevant math paper (originally) had a
> flaw in the claim that quad parity and above can be implemented just
> like triple parity.
>
> I don't know the implementation you were going to use, neither am I
> knowledgeable about multi-parity in general. I only thought it might be
> relevant to add to the current discussion that other people had issues
> with implementing N-parity for N > 3.
>
>

I've looked at Adam's blog article - in fact, stumbling over it when 
wandering around the 'net was one of my inspirations to think about 
multi-parity raid again.

But there are a few key differences between the description in the James 
Plank papers referenced, and the implementation I've looked at.

One point is that he is looking at GF(2^4), which is quickly a limiting 
factor.  It's hard to get enough independent parity syndromes, and you 
can get easily start to think that things won't work for larger parity.

The other is the choice of factors for the syndromes.  Assuming I 
understand the papers correctly, the first paper is suggesting this 
arrangement (all arithmetic done in GF()):

P_0 = 1^0 . d_0  +  2^0 . d_1  +  3^0 . d_2  +  4^0 . d_3
P_1 = 1^1 . d_0  +  2^1 . d_1  +  3^1 . d_2  +  4^1 . d_3
P_2 = 1^2 . d_0  +  2^2 . d_1  +  3^2 . d_2  +  4^2 . d_3
P_3 = 1^3 . d_0  +  2^3 . d_1  +  3^3 . d_2  +  4^3 . d_3

The second paper changes it to:

P_0 = 1^0 . d_0  +  1^1 . d_1  +  1^2 . d_2  +  1^3 . d_3
P_1 = 2^0 . d_0  +  2^1 . d_1  +  2^2 . d_2  +  2^3 . d_3
P_2 = 3^0 . d_0  +  3^1 . d_1  +  3^2 . d_2  +  3^3 . d_3
P_3 = 4^0 . d_0  +  4^1 . d_1  +  4^2 . d_2  +  4^3 . d_3


For the first two parity blocks, this is the same as for Linux raid6:

P = d_0 + d_1 + d_2 + d_3
Q = g^0 . d_0  +  g^1 . d_1  +  g^2 . d_2  +  g^3 . d_3
(where g = 2)

But the third (and later) lines are not good - the restoration equations 
on multiple disk failure are not independent for all combinations of 
failed disks.  For example, if you have 20 data disks and 3 parity 
disks, there are 1140 different combinations of three data-disk 
failures.  Of these, 92 combinations lead to non-independent equations 
when you try to restore the data.


The equations I am using are:

P_0 = 1^0 . d_0  +  1^1 . d_1  +  1^2 . d_2  +  1^3 . d_3
P_1 = 2^0 . d_0  +  2^1 . d_1  +  2^2 . d_2  +  2^3 . d_3
P_2 = 4^0 . d_0  +  4^1 . d_1  +  4^2 . d_2  +  4^3 . d_3
P_3 = 8^0 . d_0  +  8^1 . d_1  +  8^2 . d_2  +  8^3 . d_3

P_4 would use powers of 16, etc.

I have checked that the restoration equations are solvable for all 
combinations of 3 disk failures for triple parity, and all combinations 
of 4 disk failures for quad parity.  The restoration equations can be 
written in matrix form and are dependent on the indexes of the failed 
disks.  To solve them, you simply invert the matrix and this gives you a 
linear formula for re-calculating each missing data block.  So to check 
that the data can be restored, you need to check that the determinant of 
this matrix is non-zero for all combinations of n-disk failures.

I /believe/ these should work find for at least up to P_7 (i.e., 8 
parity disks), but I haven't yet checked more than a few larger parity 
modes.  Checking all 4 disk failures from 253 disks took my inefficient 
python program about 45 minutes - to check for 8-disk failures would 
mean finding all combinations of 8 choices for up to 249 disks.  If my 
maths serves me right, that's 316,528,258,780,856 combinations - and for 
each one, I'd have to find the determinant of an 8x8 matrix over 
GF(2^8).  Fortunately, I don't think they'll be much call for 
octal-parity RAID in the near future :-)


Of course, all this assume that my maths is correct !


