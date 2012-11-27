From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 14:20:39 +0100
Message-ID: <50B4BE27.1050101@hesbynett.no>
References: <2920513.16.1354021770710.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2920513.16.1354021770710.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

On 27/11/2012 14:09, Roy Sigurd Karlsbakk wrote:
>> One way to handle this at md block level would be to have an
>> option for raid arrays to always do a full stripe read and
>> consistency check whenever a block is read. If the consistency
>> check fails (without any errors being indicated from the drives),
>> the array should simply return a read error - it should /not/
>> attempt to recover the data (since it can't tell which parts are
>> the real problem). If arrays with this option are used as
>> first-level arrays, with a "normal" md raid array (raid1, raid5,
>> etc.) on top, then the normal raid recovery process will replace
>> the bad data and initiate a new write to correct the undetected
>> read error. I think this would perhaps give you the level of
>> reliability you are looking for, and be suitable for big arrays
>> (indeed, it would be unsuitable for small arrays as you need at
>> least two levels).
>
> If this system is running RAID-6, recovery should be possible to
> check both parity chunks, right?

Yes, of course.  (And if anyone ever needs it, it is possible to extend=
=20
raid6 to 3 parity chunks.  I've done the maths, but it is not=20
implemented - there doesn't seem to be a big need for it.)  But - again=
=20
referring back to Neil's blog - if the low-level raid spots a=20
consistency error, it still cannot correct it reliably even with 2=20
parity chunks, and should pass on a read error to the higher level raid=
=2E=20
  Using raid6 at the low level would let you do a good consistency chec=
k=20
even in the case of a failed drive (or a known read error on a drive) -=
=20
or two simultaneous undetected read errors.  And raid6 on the higher=20
level raid would let you correct such errors, even when there are other=
=20
errors around.  You'd soon reach the point where it is more likely for=20
your disks to spontaneously turn into a bowl of petunias than for read=20
errors to be undetected or unrecoverable.

>
> Vennlige hilsener / Best regards
>
> roy -- Roy Sigurd Karlsbakk (+47) 98013356 roy@karlsbakk.net
> http://blogg.karlsbakk.net/ GPG Public key:
> http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt -- I all
> pedagogikk er det essensielt at pensum presenteres intelligibelt. Det
> er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv
> anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller
> eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
