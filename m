From: David Greaves <david@dgreaves.com>
Subject: Re: Dual disk RAID 5 failure!
Date: Thu, 25 Nov 2004 19:31:52 +0000
Message-ID: <41A63328.40907@dgreaves.com>
References: <A6264114-3F0D-11D9-8034-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-admin@lists.sourceforge.net>
In-Reply-To: <A6264114-3F0D-11D9-8034-000A959A30DC@postbox.org.uk>
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: Chris Birkinshaw <chris@postbox.org.uk>
Cc: linux-raid@vger.kernel.org, evms-devel@lists.sourceforge.net
List-Id: linux-raid.ids

certainly cc the guys on linux-raid - a *great* bunch :)

you'll need more detail on your config though - have you got mdadm 
installed?

mdadm --detail /dev/md0

any log output?

David

Chris Birkinshaw wrote:

>
>
> Hi,
>
> Last night one of my drives got corrupted during a crash, but also 
> corrupted the other drive on that controller (I know I should only 
> have one drive per controller but you know how it is.... stable door 
> and all that).
>
> So I now have 2 disks missing from my RAID 5 with corrupt superblocks. 
> Is there any way to get back from this, there was around 400Gb of data 
> on there....
>
> If anyone has any idea at all that may help I would be very happy to 
> hear it,
>
> Many thanks,
>
> Chris
>
>



-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
