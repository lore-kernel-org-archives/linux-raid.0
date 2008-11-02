From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Sun, 2 Nov 2008 14:47:07 +0100
Message-ID: <20081102134707.GA21279@maude.comedia.it>
References: <18692.62860.863118.727187@notabene.brown> <1225387127.26510.155.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1225387127.26510.155.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 30, 2008 at 01:18:47PM -0400, Doug Ledford wrote:
>>  4/ auto-assembly needs to do the right thing on a SAN where multiple
>>     hosts can each see multiple arrays.  Clearly only one host should
>>     write to any one array at one time (until I get some
>>     cluster-awareness going, which I had hoped to work on this year,
>>     but it doesn't look like I will).
>>     In this case, I don't think read-auto is enough.  We either need
>>     to not assemble arrays when aren't known to belong to us, or we
>>     need to assemble them read-only and require and explicit
>>     read-write setting.
>> 
>>     So we need some way to know which devices could be visible to
>>     other hosts.
>>     I could have a global flag in mdadm.conf "Options SAN"
>>     I could have a SAN-DEVICES to match "DEVICES", but as just about
>>     everything is "/dev/sd*" these days, I don't know if that would
>>     work.
>> 
>>     Any suggestions concerning this would be welcome.
>
>The scariest suggestion, but probably the most complete and automated,
>would be to have mdadm do a search on any constituent devices to find
>out what the eventual low level driver is.  If it's a fiber channel
>driver, or iSCSI, then don't auto assemble.  If it's sata/e-sata, or
>local SAS, then it's more likely auto assemble is fine.  But, that level
>of mucking around in /sys for each device would probably be quite ugly.
>

unfortunately this will not work out correctly
1) it is fairly possible for an host to boot from fiber-channel, and to
run md over it (it is a fairly common setup here).
2) scsi supports shared storage, and i believe SAS does too.

L.




-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
