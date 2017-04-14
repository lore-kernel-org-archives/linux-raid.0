From: linuxknight <linuxknight@gmail.com>
Subject: Re: Linux software raid troubles
Date: Fri, 14 Apr 2017 11:01:45 -0400
Message-ID: <CAAO=44YCU+OF-xBytuMCHEtV7WbHE6EVyJ_9ncGmM9VNWcj9MA@mail.gmail.com>
References: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
 <8e9a25fc-5c81-103c-2ffa-4b46f2aa8630@thelounge.net> <CAAO=44bsG1yrmYbag1eruNA_tdXxqiJptnRyPB=4TW6r5771HQ@mail.gmail.com>
 <cbadbdeb-7e6b-7784-e49c-dd2801903bb6@thelounge.net> <CAAO=44Y9YspCqyfvDgx30mGO_VhYZpuj9D8U1O6063B8VL61vw@mail.gmail.com>
 <d1695ac6-5912-860a-0b70-e0d9a322002e@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1695ac6-5912-860a-0b70-e0d9a322002e@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David thanks for this additional follow-up.  I was mistaken about the
LSI card, it was actually a SiL 3124.  The OS didnt see the raid as
one drive, so its another one of these fake raid cards.  I did get a
good image.so Im going to re-os this weekend and use the software raid
method.

One last question, is it acceptable to let graphical installers setup
the software raid for me or should I use one disk and create a raid
mirror later once the OS is setup?

On Fri, Apr 14, 2017 at 12:43 AM, David C. Rankin
<drankinatty@suddenlinkmail.com> wrote:
> On 04/12/2017 10:36 AM, linuxknight wrote:
>> Thank you Reindl, Using your method would I be able to apply this IMG
>> file to a fresh raid1 mirror and still have it be bootable?
>>
>> The reason I ask is I was looking at this guide,
>> https://www.data-medics.com/forum/how-to-clone-a-hard-drive-with-bad-sectors-using-ddrescue-t133.html
>> It has a method to transfer drive to drive.  I was thinking I would
>> create the fresh RAID mirror on the dedicated LSI card, then ddrescue
>> possibly bad drive to the new raid mirror.  Is this a bad idea?
>
> Take the dd advise, but... you initially indicated:
>
> <quote>
> I was moving a server with a raid1 configuration,
> controlled by a Intel Corporation 82801 SATA RAID Controller
> </quote>
>
> Now you are saying
>
> <quote>
>> It has a method to transfer drive to drive.  I was thinking I would
>> create the fresh RAID mirror on the dedicated LSI card
> </quote>
>
> Note: the Intel and LSI cards may not have compatible RAID metadata. (That is
> one of the major benefits of using linux-raid (software RAID) you are not
> constrained by differing hardware RAID specifications.)
>
> You also mention "to a fresh raid1 mirror and still have it be bootable?" If
> you image the drive with dd, the mbr or bootloader will still be present on in
> the image and on the drive, so as long as you can tell the OS to boot from
> that drive you should be fine (as long as the controller can access the
> information)
>
> A good general howto on setting up linux-raid is
> https://wiki.archlinux.org/index.php/RAID
>
> --
> David C. Rankin, J.D.,P.E.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
