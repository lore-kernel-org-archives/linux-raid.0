From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Sat, 22 Mar 2008 15:00:46 +0100
Message-ID: <47E5110E.6020909@tuxes.nl>
References: <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <20080321171348.GK7991@mit.edu> <47E3F1EF.3030705@rabbit.us> <20080322132733.GR7991@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080322132733.GR7991@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Theodore Tso wrote:
> On Fri, Mar 21, 2008 at 06:35:43PM +0100, Peter Rabbitson wrote:
>   
>> Of course it would be possible to instruct md to always read all 
>> data+parity chunks and make a comparison on every read. The performance 
>> would not be much to write home about though.
>>     
>
> (...)
>
> Does it happen as much as ZFS's marketing literature implies?
> Probably not.  But as you start making bigger and bigger filesystems,
> the chances that even relatively improbable errors happen start
> increasing significantly.  Of course, the flip side of the argument is
> that if you are using the huge arrays to store things like music and
> video, maybe you don't care about a small amount of data corruption,
> since it might not be noticeable to the human eye/ear.  That's a
> pretty weak argument though, and it sends shivers up the spins of
> people who are storing, for example, medical images of X-ray or CAT
> scans.
>   
I totally agree with you, Ted, although I think your idea of a
filesystem communicating with RAID in an sophisticated way kind of
conflicts with the "layered approach" which is chosen in the world of
Linux. Should that be a reason not to implement this feature? I don't
think so.

Although most of you sketch scenarios in which it is very rare that
corruptions occur, I think you should also take into account that
storage is booming and growing like never before. This trend has caused
people (like me) to use other media to transfer and store data, using
the network for example. The assumption that data corruption is rare
because the bus and the disk are very reliable doesn't hold anymore:
other ways of communication are much more sensitive to corruption.

Of course, protection against these types of corruption should be
implemented in the appropriate layer (using checksums over packets, like
TCP does), but I think it is a little bit naive to assume that this will
succeed in all cases. On the other hand it would not make sense to read
every block after writing it (to check its consistency), but it might be
a nice feature to extend the monthly consistency check with advanced
error reporting features. Users who don't care (storing music and video,
using Ted's example) would disable this check, administrators like me
(storing large amounts of medical data) could run this check every week
or so.

Regards,

  -- Bas
