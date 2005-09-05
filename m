From: Luca Berra <bluca@comedia.it>
Subject: Re: MD or MDADM bug?
Date: Mon, 5 Sep 2005 23:13:42 +0200
Message-ID: <20050905211341.GB11060@percy.comedia.it>
References: <17176.9057.119383.787644@cse.unsw.edu.au> <01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH> <17176.13548.477061.774536@cse.unsw.edu.au> <001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH> <17176.51414.689631.346198@cse.unsw.edu.au> <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH> <17177.7688.922030.788691@cse.unsw.edu.au> <43195D20.1070103@dtbb.net> <17178.37305.857263.952767@cse.unsw.edu.au> <62b0912f05090509457a790e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62b0912f05090509457a790e22@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 05, 2005 at 06:45:30PM +0200, Molle Bestefich wrote:
>Neil Brown wrote:
>> No.
>> I've never liked kernel autodetect, and while I won't break it, I
>> would like to migrate people away from it.
>[snippet]
>> I hope you find that acceptable.
>
>I won't go as far as to insinuate that I know what is acceptable and
>what is not.
>But I definitely like autodetection a lot.

because it never bit you :-)

>I'm having troubling seeing why you'd like every MD user out there to
>start fiddling with mdadm commands in their initrd when it can all be
>done automatically behind the scenes.
>I'm a big fan of letting computers do manual labour (especially MY
>manual labour), and preferably doing it intelligently.
there is no reason for user to fiddle with md commands.
just have the command used to create initrd handle this, i have been
doing this for ages

>I hope you have the time to enlighten me! :-).
>
>> What will, very likely, be implemented is something in 'mdadm' which
>> automatically detects and assembles md arrays.
>
>If that implies that all that distros have to do is put 'mdadm
>--auto-assemble' into initrd, and it will do the same as kernel
>autodetection does, I for one would be happy happy.
it would actually work, versus autodetection which does not always.

>> You run
>>   mdadm -As --config=partitions --hostid=notabene
>> 
>> then it scans all partitions for md arrays, looks at those with
>> 'notabene' as the hostname in the 'name' field, and assembles them,
>
>So if you change your hostname, you have to modify your initrd?
no, it is just a tag, it is unrelated to the gethostname() syscall.

>I fail to see what the added complexity might bring of good things to the table.
you probably never had to deal with shared storage

>> Such a command would reliably assemble all arrays with any need for a
>> config file, and without any risk of getting confused if arrays are
>> imported from another machine (which is one of my issues with
>> autodetect).
>
>Who's confused?
>MD or the user?
autodetect is confused.

< big snip>
>
>I'm curious about what the current status of layered MD device detection is!
recent mdadm in the 1.xx series work flawlessly.
in kernel auto-detection, well....

in any case autodetection does not belong in the kernel.
it is far easier to implement and maintain in userspace.
the only reason why it has not been completely removed is backwards
compatibility.
if you don't want to use an initrd use the kernel command line.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
