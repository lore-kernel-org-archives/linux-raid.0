From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Mon, 29 Oct 2007 22:44:16 +0100
Message-ID: <20071029214416.GB24635@percy.comedia.it>
References: <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com> <20071026223046.GB8210@boogie.lpds.sztaki.hu> <1193531160.10336.397.camel@firewall.xsintricity.com> <20071028141336.GC22861@percy.comedia.it> <1193593675.10336.404.camel@firewall.xsintricity.com> <20071029084118.GC15475@percy.comedia.it> <1193671853.10336.428.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193671853.10336.428.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 29, 2007 at 11:30:53AM -0400, Doug Ledford wrote:
>On Mon, 2007-10-29 at 09:41 +0100, Luca Berra wrote:
>
>> >Remaking the initrd installs the new mdadm.conf file, which would have
>> >then contained the whole disk devices and it's UUID.  There in would
>> >have been the problem.
>> yes, i read the patch, i don't like that code, as i don't like most of
>> what has been put in mkinitrd from 5.0 onward.
in case you wonder i am referring to things like

emit dm create "$1" $UUID $(/sbin/dmsetup table "$1")

>> Imho the correct thing here would not have been copying the existing
>> mdadm.conf but generating a safe one from output of mdadm -D (note -D,
>> not -E)
>
>I'm not sure I'd want that.  Besides, what makes you say -D is safer
>than -E?

"mdadm -D  /dev/mdX" works on an active md device, so i strongly doubt the information
gathered from there would be stale
while "mdadm -Es" will scan disk devices for md superblock, thus
possibly even finding stale superblocks or leftovers.
I would strongly recommend against blindly doing "mdadm -Es >>
/etc/mdadm.conf" and not supervising the result.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
