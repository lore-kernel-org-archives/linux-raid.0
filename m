From: David Brown <david.brown@hesbynett.no>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 15:46:03 +0200
Message-ID: <553E3D9B.8000801@hesbynett.no>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <4ADD42F9-407A-4266-A1FC-B92F3D46C36F@insync.za.net> <743316986.23005258.1430129889889.JavaMail.zimbra@laposte.net> <553E1559.2010305@hesbynett.no> <1441590395.23298447.1430138211592.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441590395.23298447.1430138211592.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/15 14:36, Jean-Baptiste Thomas wrote:
> On 2015-04-27 12:54 +0200, David Brown wrote:
> 
>> The problem with all of these is that they /might/ be right -
>> but they /might/ be wrong and make matters worse.  Even if you
>> have 3 copies of the sector, and get two matches and one
>> different, there is no way to determine that the odd one is
>> wrong.  Perhaps a common bus or connector fault caused the
>> other two to be wrong.  Picking the "majority vote" may
>> decrease your chances of losing data (but may not - it depends
>> on the cause of the fault), but it certainly does not avoid
>> the worst case scenario.
> 
> So Neil's objection is that it's too paranoid and yours is that
> it's not paranoid enough ? :-)

It's both - it's unlikely to be needed, and in cases where it is needed,
it's unlikely to help.

Neil has written articles about this before, which are worth reading:

<http://neil.brown.name/blog/20110227114201>
<http://neil.brown.name/blog/20100211050355>


> 
>> Perhaps the best choice during normal usage (as distinct from
>> recovery or rebuild, when the drive is not mounted) is to
>> simply report a failure to the layers higher up - that way you
>> won't make matters worse by giving returning data.
> 
> You may be right. The main points I think are that
> a) the inconsistency be caught and reported and
> b) writes be disabled before the propagation of errors buggers
>    up the whole file system.

Yes, that all makes sense.


