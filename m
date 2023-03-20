Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A152CC7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 13:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjCTNwc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCTNw3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 09:52:29 -0400
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F798A5D9
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 06:52:28 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 0CFA91E6EC;
        Mon, 20 Mar 2023 09:52:27 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 06A96A84CC; Mon, 20 Mar 2023 09:52:25 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25624.25881.927883.554758@quad.stoffel.home>
Date:   Mon, 20 Mar 2023 09:52:25 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Asaf Levy <asaf@vastdata.com>
Cc:     Geoff Back <geoff@demonlair.co.uk>,
        John Stoffel <john@stoffel.org>,
        Ronnie Lazar <ronnie.lazar@vastdata.com>,
        linux-raid@vger.kernel.org
Subject: Re: Question about potential data consistency issues when writes
 failed in mdadm raid1
In-Reply-To: <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
        <25620.54403.944889.209021@quad.stoffel.home>
        <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
        <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk>
        <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Asaf" == Asaf Levy <asaf@vastdata.com> writes:

> Thank you for the clarification.
> To make sure I fully understand.

> An application that requires consistency should use O_DIRECT and
> enforce an R/W lock on top of the mirrored device?

No, it's more complicated than that.  Remember, you also have a
filesystem on there, and different filesystems have different
semantics for write(2) system calls.  But in POSIX, writes should only
return when the data is on the disk, or return an error which you need
to handle properly. 

So a write to a RAID device (doesn't matter which type) should only
return when the data is written to all members of the RAID group.  If
it doesn't, it's really quite broken.  

The other way to really make sure you're data is written properly is
to call the 'syncfs()' call after you do a write which you want to
confirm is on the disks properly.  

But again, you really haven't given enough details on what you are
trying to do here, and what problem you are trying to solve.  

If you have a local SSD, and then you have a remote NBD (Network Block
Device) running across the country at the end of a 80 milisecond link,
and you're using RAID1 on those two devices, then your write
performance will be limited by the remote device.  Writing to the MD
device holding those two devices will have to wait until the remote
device acknowledges the write back, which will take time.  

John



> Asaf

> On Sun, Mar 19, 2023 at 11:55 AM Geoff Back <geoff@demonlair.co.uk> wrote:
>> 
>> Hi Asaf,
>> 
>> Yes, in principle there are all sorts of cases where you can perform a
>> read of newly written data that is not yet on the underlying disk and
>> hence the possibility of reading the old data following recovery from an
>> intervening catastrophic event (such as a crash).  This is a fundamental
>> characteristic of write caching and applies with any storage device and
>> any write operation where something crashes before the write is complete
>> - you can get this with a single disk or SSD without having RAID in the
>> mix at all.
>> 
>> The correct and only way to guarantee that you can never have your
>> "consistency issue" is to flush the write through to the underlying
>> devices before reading.  If you explicitly flush the write operation
>> (which will block until all writes are complete on A, B, M) and the
>> flush completes successfully, then all reads will be of the new data and
>> there is no consistency issue.
>> 
>> Your scenario describes a concern for the higher level code, not in the
>> storage system.  If your application needs to be absolutely certain that
>> even after a crash you cannot end up reading old data having previously
>> read new data then it is the responsibility of the application to flush
>> the writes to the storage before executing the read.  You would also
>> need to ensure that the application cannot read from the data between
>> write and flush; there's several different ways to achieve that
>> (O_DIRECT may be helpful).  Alternatively, you might want to look at
>> using something other than the disk for your data interchange between
>> processes.
>> 
>> Regards,
>> 
>> Geoff.
>> 
>> Geoff Back
>> What if we're all just characters in someone's nightmares?
>> 
>> On 19/03/2023 09:13, Asaf Levy wrote:
>> > Hi John,
>> >
>> > Thank you for your quick response, I'll try to elaborate further.
>> > What we are trying to understand is if there is a potential race
>> > between reads and writes when mirroring 2 devices.
>> > This is unrelated to the fact that the write was not acked.
>> >
>> > The scenario is: let's assume we have a reader R and a writer W and 2
>> > MD devices A and B. A and B are managed under a device M which is
>> > configured to use A and B as mirrors (RAID 1). Currently, we have some
>> > data on A and B, let's call it V1.
>> >
>> > W issues a write (V2) to the managed device M
>> > The driver sends the write both to A and B at the same time.
>> > The write to device A (V2) completes
>> > R issues a read to M which directs it to A and returns the result (V2).
>> > Now the driver and device A fail at the same time before the write
>> > ever gets to device B.
>> >
>> > When the driver recovers all it is left with is device B so future
>> > reads will return older data (V1) than the data that was returned to
>> > R.
>> >
>> > Thanks,
>> > Asaf
>> >
>> > On Fri, Mar 17, 2023 at 10:58 PM John Stoffel <john@stoffel.org> wrote:
>> >>>>>>> "Ronnie" == Ronnie Lazar <ronnie.lazar@vastdata.com> writes:
>> >>> I'm trying to understand how mdadm protects against inconsistent data
>> >>> read in the face of failures that occur while writing to a device that
>> >>> has raid1.
>> >> You need to give a better test case, with examples.
>> >>
>> >>> Here is the scenario: I have set up raid1 that has 2 mirrors. First
>> >>> one is on local storage and the second is on remote storage.  The
>> >>> remote storage mirror is configured with write-mostly.
>> >> Configuration details?  And what is the remote device?
>> >>
>> >>> We have parallel jobs: 1 writing to an area on the device and the
>> >>> other reading from that area.
>> >> So you create /dev/md9 and are writing/reading from it, then the
>> >> system crashes and you lose the local half of the mirror, right?
>> >>
>> >>> The write operation writes the data to the first mirror, and at that
>> >>> point the read operation reads the new data from the first mirror.
>> >> So how is your write succeeding if it's not written to both halves of
>> >> the MD device?  You need to give more details and maybe even some
>> >> example code showing what you're doing here.
>> >>
>> >>> Now, before data has been written to the second (remote) mirror a
>> >>> failure has occurred which caused the first machine to fail, When
>> >>> the machine comes up, the data is recovered from the second, remote,
>> >>> mirror.
>> >> Ah... some more details.  It sounds like you have a system A which is
>> >> writing to a SITE local remote device as well as a REMOTE site device
>> >> in the MD mirror, is this correct?
>> >>
>> >> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
>> >> please.
>> >>
>> >>> Now when reading from this area, the users will receive the older
>> >>> value, even though, in the first read they got the newer value that
>> >>> was written.
>> >>> Does mdadm protect against this inconsistency?
>> >> It shouldn't be returning success on the write until both sides of the
>> >> mirror are updated.  But we can't really tell until you give more
>> >> details and an example.
>> >>
>> >> I assume you're not building a RAID1 device and then writing to the
>> >> individual devices behind it's back or something silly like that,
>> >> right?
>> >>
>> >> John
>> >>
>> 
