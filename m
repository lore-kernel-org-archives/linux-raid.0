From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 13:31:38 +0100
Message-ID: <50B4B2AA.5010809@fastmail.fm>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no> <50B4934F.6060105@fastmail.fm> <50B4A215.4000203@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4A215.4000203@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/27/2012 12:20 PM, David Brown wrote:
> I can certainly sympathise with you, but I am not sure that data
> checksumming would help here.  If your hardware raid sends out nonsense,
> then it is going to be very difficult to get anything trustworthy.  The

When a single hardware unit (any kind of block device) in a
raid-level > 0 decides to send wrong data, correct data always can be 
reconstructed. You only need to know which unit it is - checksums help 
to figure that out.

> obvious answer here is to throw out the broken hardware raid and use a
> system that works - but it is equally obvious that that is easier said
> than done!  But I would find it hard to believe that this is a common
> issue with hardware raid systems - it goes against the whole point of
> data storage.

With disks it is not that uncommon. But yes, hardware raid controllers 
usually do not scramble data.

>
> There is always a chance of undetected read errors - the question is if
> the chances of such read errors, and the consequences of them, justify
> the costs of extra checking.  And if they /do/ justify extra checking,
> are data checksums the right way?  I agree with Neil's post that
> end-to-end checksums (such as CRCs in a gzip file, or GPG integrity
> checks) are the best check when they are possible, but they are not
> always possible because they are not transparent.

Everything below block or filesystem level is too late. Just remember, 
writing not a complete stripe implies reads in order to update the p and 
q parity blocks. So even if your application could later on detect that 
(Do your applications usually verify checksums?  In HPC I don't know of 
a single application to do that...), file system meta data already would 
be broken.

Cheers,
Bernd

