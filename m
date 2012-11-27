From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 10:45:14 +0100
Message-ID: <50B48BAA.8060903@hesbynett.no>
References: <14319197.21.1353936449959.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14319197.21.1353936449959.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/11/2012 14:27, Roy Sigurd Karlsbakk wrote:
> Hi all
>
> I see from an article at
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf
> that an implementation has been made to allow for ZFS-like
> checksumming inside Linux MD. However, this code doesn't seem to
> exist in any kernel trees. Does anyone know the current status for
> data checksumming in MD?
>

See <http://neil.brown.name/blog/20110227114201> for a discussion on 
data checksums.

As far as I have seen on this mailing list, there has been no "official" 
work on checksums as described in that paper.  I suspect it's just a 
matter of a student or two doing a project as part of their university 
degree.  It's great that people can do that - they are free to take a 
copy of the kernel, and experiment with new ideas.  If the ideas are 
good, then it is possible to work it back into the mainline kernel 
development.

However, in this case I think there is not much support for data 
checksumming amongst the "big boys" in this part of the Linux kernel - 
as explained by Neil in his blog post.

My first thought when reading the paper in question is that it doesn't 
really add much that is actually useful.  md does not need checksums - 
it already has a more powerful system for error detection and correction 
through the parity blocks.  If you want more checksumming than raid5 
gives you, then use raid6.

What might be of interest for confirming the data integrity is so say 
that whenever a block is to be read, the stripe it is in should be 
scrubbed.  This would enforce regular scrubbing of data that is 
regularly used, and give the same benefits as the article's data 
checksumming.  It would lead to more disk reads when you have small 
reads, but the overhead would be small for larger reads or for RMW 
writes (since the whole stripe, minus the parity, is read in this case).

However, referring to another of Neil's blog posts at 
<http://neil.brown.name/blog/20100211050355>, you have to ask yourself 
how likely is it that data will be read from the drive with an error, 
but without the disk telling you of the error - and what can you 
sensibly do about it?  You don't need checksums to tell you that there 
is a problem reading data from the disk - the disk already has very 
comprehensive checking of the data, and if that fails it will report an 
error and the md layer will re-construct the data from the parity and 
the rest of the stripe.

So before worrying about data checksums, please read Neil's posts, and 
try to think out scenarios where it really would help.  And if you find 
you have a good argument, then post it here.


David
