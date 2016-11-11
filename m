From: Theophanis Kontogiannis <tkonto@gmail.com>
Subject: Re: Question on blocks periodic writes
Date: Fri, 11 Nov 2016 14:13:10 +0200
Message-ID: <CAOzB0-7U76Mw7aoB9CUF3TzakGZjuAphK0X7uhEWxYRUC-vx0Q@mail.gmail.com>
References: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
 <8760nwm6vu.fsf@notabene.neil.brown.name> <58249BD9.8000303@youngman.org.uk> <87a8d6lr4t.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8d6lr4t.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Have also run the following for about 6 hours:


-bash-4.2# cat iotop-results
Total DISK READ :    0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:    0.00 B/s | Actual DISK WRITE:       0.00 B/s
  PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
  696 be/3 root          0.00 B    956.00 K  0.00 %  0.31 % [jbd2/md0-8]
  750 be/4 root          0.00 B      0.00 B  0.00 %  0.05 % smartd -n -q ne=
ver
 2134 be/4 mysql       624.00 K    344.85 M  0.00 %  0.01 % mysqld
--basedir=3D/usr --datadir=3D/mnt/md/md0/DBs/mys~riadb/mariadb.pid
--socket=3D/var/lib/mysql/mysql.sock
14110 be/4 root          0.00 B      0.00 B  0.00 %  0.01 % udisksd --no-de=
bug
 5217 be/4 root          0.00 B      0.00 B  0.00 %  0.29 % [kworker/1:0]
 2454 be/4 root          0.00 B      0.00 B  0.00 %  0.04 % [kworker/0:2]
31764 be/4 root          4.00 K      0.00 B  0.00 %  0.00 % -bash
 2368 be/4 root          0.00 B      0.00 B  0.00 %  0.01 % [kworker/1:3]
 4584 be/4 root          0.00 B      0.00 B  0.00 %  0.00 % [kworker/1:1]
 5265 be/4 root          0.00 B      0.00 B  0.00 %  0.00 % [kworker/0:0]
 4595 be/4 root          0.00 B      0.00 B  0.00 %  0.00 % [kworker/0:1]
31747 be/4 root          0.00 B      8.00 K  0.00 %  0.00 % sshd: root@pts/=
3
  761 be/4 root          0.00 B     10.20 M  0.00 %  0.00 % rsyslogd -n
 7437 be/4 apache        0.00 B     24.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
14625 be/4 apache        0.00 B     20.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
10059 be/4 apache        0.00 B      8.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
10062 be/4 apache        0.00 B     24.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
10094 be/4 apache        0.00 B     16.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
10095 be/4 apache        0.00 B     20.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
10141 be/4 apache        0.00 B     24.00 K  0.00 %  0.00 % httpd -DFOREGRO=
UND
12220 be/4 root          0.00 B      9.99 M  0.00 %  0.00 % python
/usr/bin/weewxd --daemon --pidfile=3D/var/run/weewx.pid
/etc/weewx/weewx.conf

---
Best regards,
=CE=9C=CE=A6=CE=A7,

Theophanis Kontogiannis



On Fri, Nov 11, 2016 at 3:52 AM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Nov 11 2016, Wols Lists wrote:
>
>> On 10/11/16 02:00, NeilBrown wrote:
>>>> [ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)
>>> This is XFS doing something.  md cannot possibly stop all IO while the
>>> filesystem performs occasional IO.  If these continue, you need to
>>> discuss with xfs developers how to stop it.  If the writes to individua=
l
>>> drives continue after there are no writes to 'md1', then it is worth
>>> coming back here to ask.
>>>
>>>
>> Would the new journal feature be any help?
>
> Probably not, though until we know what is causing the writes, it is
> hard to say.
>
>>
>> I haven't dug in enough to understand it properly, and it would increase
>> the vulnerability of the system to a journal failure, but the feature
>> itself seems almost perfect for batching writes and enabling the disks
>> to spin down for extended periods.
>
> You might be able to build functionality onto the journal which allows
> the drives in the main array to stay idle for longer, but it doesn't try
> to do that at present.
>
> NeilBrown
