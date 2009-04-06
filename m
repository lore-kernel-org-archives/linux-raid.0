From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID halting
Date: Mon, 6 Apr 2009 08:37:37 -0400
Message-ID: <9AE8E4A4-6B28-4A85-919A-FAE1425905C3@redhat.com>
References: <20090406015357.NYON1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-19-868736186"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090406015357.NYON1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-19-868736186
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 5, 2009, at 9:53 PM, Leslie Rhorer wrote:

>> Well said.  I found it particularly interesting to hear David talk of
>> statistical probabilities as he studiously ignored the astronomical
>> statistical improbability that sector remapping would strike only on
>> file creation, and would simultaneously block a drive up for the
>> purpose of file creation but not block it up for the purpose of raid
>> sector checking.
>
> I know.  I was apoplectic.  I truly didn't know how best to respond  
> to such
> a glaring incongruity.  It's likely the average sector in the free  
> space
> region has been read 50 times or more without a single instance of the
> failure, yet under load every single creation causes a halt.   
> 'Billions of
> sectors read over, and over, and over again, yet perform a file  
> create to
> one or two from the very same sector space, and kerplewey!  It  
> boggled my
> mind.
>
>> David definitely went on a "short bus" rant, I'd
>> just ignore the rant
>
> I was trying to, mostly.  I've never heard the term, "short bus",  
> before.  I
> presume it refers to what can happen on a computer bus with an  
> electrical
> short?

No, much more insulting and definitely not politically correct speech,  
hence my lack of further explanation.

>  What really gets me is rather than going on and on about how
> ignorant I was, all he had to do in his very first message was say,  
> "Try the
> badblocks command."
>
>> Personally, I've
>> only ever used badblocks for low level disk checking, but back when I
>> used it for diagnosis drives were different than they are today in
>> terms of firmware and you could actually trust that badblocks was
>> doing something useful.
>
> Am I mistaken in believing, per the discussion in this list, it should
> trigger an event, provided the problem really is bad blocks on one  
> or more
> drives?

It should, yes.  It merely attempts to read the entire block device,  
without any regards to filesystem layout or anything like that.  Since  
it reads the entire block device, it covers the metadata, the journal,  
and everything else. There shouldn't be anything that the filesystem  
touches that bad blocks doesn't.  In the old days, when bad blocks  
gave you a bad block number, it meant something, now a days it doesn't  
mean much due to changes in disk firmware.  So even if it doesn't give  
you what you need to manually map bad blocks out of the filesystem  
well, it should still replicate your hangs if the hangs are truly bad  
block remapping related.

>  If so, then I need someone to explain a bit more what badblocks
> does, and perhaps point me toward some low level test which will  
> potentially
> either rule out or convict the drive layer of being the source of  
> issues.
> I've never used it before, quite obviously.  I read the MAN page, of  
> course,
> but as is typical with MAN pages, it doesn't go into any detail  
> under the
> hood, as it were.

All it really does under the hood in the non-destructive case is read  
from block 0 to block (size-1) and see if any of them report errors  
via the OS.  In destructive write tests, it writes patterns and sees  
if they read back properly.  I think there is a non-destructive write  
test that's supposed to read/modify/read/restore or something like  
that, but obviously it can't be used on a live filesystem.  Only the  
read test is safe on a live filesystem.

>
> Oh, just BTW, I have the system set to notify me via e-mail of any  
> events
> passing through the Monitor daemon of mdadm.  Will this notify me if  
> the
> RAID device encounters any errors requiring recovery at the RAID  
> level?  If
> so, I have never received any such notifications since implementing  
> mdadm.

I don't think so.  The mdadm --monitor functionality simply watches  
the output of /proc/mdstat watching for changes in the array's listed  
state, such as a transition from active to degraded.  On those  
changes, it mails the admin.  However, if you are running a resync/ 
check, this is considered a good state like active is.  So mdadm would  
only send you a mail if the array encountered an unrecoverable problem  
that kicked the array from a good state to a degraded state.  The  
whole monitor capability of mdadm is probably due for a rewrite now  
that sysfs usage is pervasive.  It should probably ignore /proc/mdstat  
and instead use the sysfs files, and it should check for more things  
than just a transition from active->degraded, it should also check  
things like mismatch_cnt after a check/resync completes, things like  
that.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-19-868736186
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknZ95EACgkQQ9aEs6Ims9jzBgCeNMvElRugPRGBkpEwDpGtY+KW
k7EAoM71Rh60RnaASKgsb7y445GvvKx0
=3OjJ
-----END PGP SIGNATURE-----

--Apple-Mail-19-868736186--
