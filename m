From: Luca Berra <bluca@comedia.it>
Subject: Re: Problem with auto-assembly on Itanium
Date: Thu, 10 Mar 2005 21:49:41 +0100
Message-ID: <20050310204940.GD9714@percy.comedia.it>
References: <1110364128.14707.19.camel@localhost> <20050309164352.GB21635@percy.comedia.it> <1110449024.12242.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1110449024.12242.2.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 10, 2005 at 11:03:44AM +0100, Jimmy Hedman wrote:
>On Wed, 2005-03-09 at 17:43 +0100, Luca Berra wrote:
>> On Wed, Mar 09, 2005 at 11:28:48AM +0100, Jimmy Hedman wrote:
>> >Is there any way i can make this work? Could it be doable with mdadm in
>> >a initrd?
>> >
>> mdassembled was devise for this purpose.
>> 
>> create an /etc/mdadm.conf with
>> echo "DEVICE partitions" >> /etc/mdadm.conf
>> /sbin/mdadm -D -b /dev/md0 | grep '^ARRAY' >> /etc/mdadm.conf
>> 
>> copy the mdadm.conf and mdassemble to initrd
>> make linuxrc run mdassemble.
>
>So there are no way of doing it the same way i386 does it, ie scanning
>the partitions and assembly the raid by it self? Is this a bug on the
>itanium (GPT partition scheme) or is this intentional?
>
if you mean the in-kernel autodetect junk, you should only be happy it
does not work on your system, so you are not tempted to use it.
even on i386 it is badly broken, and i won't return on the subject.
it has been discussed on this list to boredom.

L.

btw. you don't need cc-ing me. i read the list.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
