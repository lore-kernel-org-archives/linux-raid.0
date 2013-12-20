From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: mdadm, spin down never happens, do spare work the same?
Date: Fri, 20 Dec 2013 23:56:14 +0000
Message-ID: <BLU0-SMTP164EF98C4A2354CB5CE42AD98C40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've noticed that with an active mdadm raid that there seems to be a
periodic polling of the devices in the array which prevents the drives
ever going into various slumber modes... and it also doesnt seem to make
a difference if the file system on the array is mounted or not (slightly
subjective as its more an observation than an in-depth testing).

I'm guessing its to make sure the array is "ok" and is also used to
update things such as /proc/mdstat and maybe other things related, so
every now and then it goes "hi, are you there disks, whats your current
state" for want of a better idea of the process.

What I'm wondering is how mdadm treats the "spare" drives, does it also
poll them periodically to the same time constraints as the active drives
or does it just check at re-boot and maybe some other periodic time
scales...

The reason for enquiring is if a "spare" drive is kept alive to the same
extent as a "live/active" drive then it means that a spare could have
been powered up and accessed for the exact same time as a running
"active" set of drives... which means that even though its never been
used it could have had the same amount of time "live/spinning" as the
existing arrays drives which would mean it is just as likely to fail due
to [running] age as any other drive within the array, if however its
only polled very sporadically (boot, maybe once a month, some other
amount) then its "active life" is drastically shortened, which would
mean its (to some degree) less likely to fail when its updated as a
"live disk" when another member has failed... obviously baring spin up
counts and other "power up=old=pre-fail" issues.

Thanks in advance.

Jon

 

 

