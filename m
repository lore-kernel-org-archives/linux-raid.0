From: George Rapp <george.rapp@gmail.com>
Subject: Re: Reshape stalls and fails when SELinux is enabled
Date: Thu, 10 Dec 2015 20:26:05 -0500
Message-ID: <CAF-KpgZXbqVcanWYVMoV9+1vVo5S7DHXPs2PD8jGbO2D6wjriw@mail.gmail.com>
References: <CAMQd7mbdqsw5BiRSKbgBqwNFrz4V8T-A3hOftWReRk1XgXc=+Q@mail.gmail.com>
 <CAMQd7mYscUDroop=4eLz4UwTEiibbF0OqDN1b28yiqJyfW7gGw@mail.gmail.com>
 <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com> <5669C34C.9060606@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5669C34C.9060606@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Edward Kuns <eddie.kuns@gmail.com>, Enrico Tagliavini <enrico.tagliavini@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Indeed, SELinux appears to be very not-helpful in the RAID resize
process. I decided to put SELINUX=disabled in /etc/selinux/config,
touch /.relabel, and reboot before doing any more RAID 6 work.

The only other workaround I could see is the ability to do a "dry run"
of mdadm operations a la wodim / growisofs - a chance to test out all
the parameters before actually pulling the trigger. (Sorry, no patch,
though ... 8^)

On Thu, Dec 10, 2015 at 1:24 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 10/12/15 17:06, Edward Kuns wrote:
>> I ran into this as well.  I unwisely worked around it by placing the
>> backup file on /tmp.  I don't recommend that choice!
>
> Most people don't realise there are various tmp directories, with
> different behaviours. /tmp is defined by LSB or somesuch to be real
> temporary storage - no guarantees - stuff may disappear at any time.
> Which is why my /tmp is a tmpfs - stored in ram. So yes, a backup file
> on /tmp is not a good idea ...
>
> /var/tmp is defined as holding data that must survive a reboot - where
> emacs and vi and that lot are recommended to store their crash dumps,
> recovery files, etc for example.
>
>  I didn't see
>> your AVC on your EMail, but I recommend you reach out to the SELinux
>> folks for labeling help.  I've reach out to them in the past and have
>> found them very helpful (as are the folks here).  Getting the labeling
>> corrected will not only help you but everyone else in the long term.
>>
>> I agree that it would be good for mdadm to handle this kind of failure
>> in a more productive fashion as well.  But I'm only a lurker here.  I
>> don't have enough knowledge to suggest what would be better.  One
>> thing that really helped me debug this was commenting out the lines
>>
>> #StandardOutput=null
>> #StandardError=null
>>
>> in the systemd file /lib/systemd/system/mdadm-grow-continue@.service
>> -- note you have to run systemctl daemon-reload after changing the
>> file for the change to be noticed.
>>
>> Once I did that, the system logs had much more useful information.
>> I'm not sure where that file is sourced, whether it's from the
>> linux-raid people or from the distributions or somewhere in between.
>> Does anyone here know if there's a reason why standard out and
>> standard error are sent to /dev/null for this service?
>>
> I wouldn't know for certain, but given the amount of junk so many
> programs spew to stdout or stderr (which nobody ever sees because
> they're running in a gui), I expect it's because that's what happens by
> default anyway :-) They don't want to clutter the logs with all that
> junk and chatter.
>
> I often somehow get stdout and stderr for various programs redirected to
> konsole, because I'll use dbus-launch to start a program. And then when
> the program has exited I'll get loads of rubbish from other programs ...
> the chatter is horrendous.
>
> Cheers,
> Wol
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
