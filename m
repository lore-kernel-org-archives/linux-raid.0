From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 23:18:13 +0200
Message-ID: <20090420211813.GB5550@maude.comedia.it>
References: <20090420181736.GB4236@lazy.lzy> <20090420194956144.ESZJ23317@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090420194956144.ESZJ23317@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 02:49:48PM -0500, Leslie Rhorer wrote:
>> >  mdadm --create /dev/md/foo --metadata 1.0 --level .....
>> >
>> > This will store the name 'foo' in the metadata and when you assemble
>> > the array, it will be called /dev/md/foo.
>> > This will be a symlink to /dev/md125 or something like that, but you
>> > don't need to care.
>> 
>> Does this really work with mdadm 2.6.7.1?
>> 
>> Because I have this from "--examine --scan"
>> 
>> ARRAY /dev/md/boot level=raid1 metadata=1.0 num-devices=2
>> UUID=edb4254d:4274fac1:dd6cad61:a8e3c347 name=boot
>
>Um, this is slightly odd, but when I use --examine --scan on my array, it
>returns nothing.  If I run it on an element of the array I get:
--examine should be run on component device
ie. mdadm --examine /dev/sda
using --scan will make it examine all devices matching the DEVICE line
in mdadm.conf (or all device if mdadm.conf does not exist)

--detail should be run on an array
ie. mdadm --detail /dev/md0

>ARRAY /dev/md0 level=raid6 num-devices=10
>UUID=5a53eeb8:4d87963b:4cb502e9:37bde716
>
>'Nothing about the metadata or the array name.
this is because you are using 0.90 metadata and did never set a name on
the device...

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
