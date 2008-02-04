From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 04:58:23 -0600
Message-ID: <47A6EFCF.9080906@pobox.com>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A6DA81.3030008@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Moshe Yudkowsky wrote:
> []
>> But that's *exactly* what I have -- well, 5GB -- and which failed. I've
>> modified /etc/fstab system to use data=journal (even on root, which I
>> thought wasn't supposed to work without a grub option!) and I can
>> power-cycle the system and bring it up reliably afterwards.
> 
> Note also that data=journal effectively doubles the write time.
> It's a bit faster for small writes (because all writes are first
> done into the journal, i.e. into the same place, so no seeking
> is needed), but for larger writes, the journal will become full
> and data found in it needs to be written to proper place, to free
> space for new data.  Here, if you'll continue writing, you will
> have more than 2x speed degradation, because of a) double writes,
> and b) more seeking.

The alternative seems to be that portions of the / file system won't 
mount because the file system is corrupted on a crash while writing.

If I'm reading the man pages, Wikis, READMEs and mailing lists correctly 
--  not necessarily the case -- the ext3 file system uses the equivalent 
of data=journal as a default.

The question then becomes what data scheme to use with reiserfs on the 
remainder of the file system, the /usr, /var, /home, and others. If they 
can recover on a reboot sing fsck and the default configuration of 
resierfs, then I have no problem using them. But my understanding is 
that data can be destroyed or lost or destroyed if there's a crash on a 
write; then there's little point in running a RAID system that can 
collect corrupt data.

Another way to phrase this: unless you're running data-center grade 
hardware and have absolute confidence in your UPS, you should use 
data=journal for reiserfs and perhaps avoid XFS entirely.


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"Right in the middle of a large field where there had never been a 
trench was a
shell hole... 8 feet deep by 15 across. On the edge of it was a dead... 
rat not over
twice the size of a mouse. No wonder the war costs so much." Col. George 
Patton
