From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Thu, 14 Sep 2017 00:55:15 -0400 (EDT)
Message-ID: <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble> <1403889957.10216459.1505268710452.JavaMail.zimbra@redhat.com> <1025458651.10368123.1505315351335.JavaMail.zimbra@redhat.com> <87o9qe9p3j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9qe9p3j.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.com>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Thursday, September 14, 2017 7:05:20 AM
> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
> 
> On Wed, Sep 13 2017, Xiao Ni wrote:
> >
> > Hi Neil
> >
> > Sorry for the bad news. The test is still running and it's stuck again.
> 
> Any details?  Anything at all?  Just a little hint maybe?
> 
> Just saying "it's stuck again" is very nearly useless.
> 
Hi Neil

It doesn't show any useful information in /var/log/messages

echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control
There aren't any messages too. 

It looks like another problem. 

[root@dell-pr1700-02 ~]# ps auxf | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      8381  0.0  0.0      0     0 ?        D    Sep13   0:00  \_ [kworker/u8:1]
root      8966  0.0  0.0      0     0 ?        D    Sep13   0:00  \_ [jbd2/md0-8]
root       824  0.0  0.1 216856  8492 ?        Ss   Sep03   0:06 /usr/bin/abrt-watch-log -F BUG: WARNING: at WARNING: CPU: INFO: possible recursive locking detected ernel BUG at list_del corruption list_add corruption do_IRQ: stack overflow: ear stack overflow (cur: eneral protection fault nable to handle kernel ouble fault: RTNL: assertion failed eek! page_mapcount(page) went negative! adness at NETDEV WATCHDOG ysctl table check failed : nobody cared IRQ handler type mismatch Machine Check Exception: Machine check events logged divide error: bounds: coprocessor segment overrun: invalid TSS: segment not present: invalid opcode: alignment check: stack segment: fpu exception: simd exception: iret exception: /var/log/messages -- /usr/bin/abrt-dump-oops -xtD
root       836  0.0  0.0 195052  3200 ?        Ssl  Sep03   0:00 /usr/sbin/gssproxy -D
root      1225  0.0  0.0 106008  7436 ?        Ss   Sep03   0:00 /usr/sbin/sshd -D
root     12411  0.0  0.0 112672  2264 pts/0    S+   00:50   0:00          \_ grep --color=auto D
root      8987  0.0  0.0 109000  2728 pts/2    D+   Sep13   0:04          \_ dd if=/dev/urandom of=/mnt/md_test/testfile bs=1M count=1000
root      8983  0.0  0.0   7116  2080 ?        Ds   Sep13   0:00 /usr/sbin/mdadm --grow --continue /dev/md0

[root@dell-pr1700-02 ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop6[7] loop4[6] loop5[5](S) loop3[3] loop2[2] loop1[1] loop0[0]
      2039808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [>....................]  reshape =  0.0% (1/509952) finish=1059.5min speed=7K/sec
      
unused devices: <none>


It looks like the reshape doesn't start. This time I didn't add the codes to check
the information of mddev->suspended and active_stripes. I just added the patches 
to source codes. Do you have other suggestions to check more things?

Best Regards
Xiao
