From: Alex Verbitsky <alexver5@mail.ru>
Subject: Re[2]: experiences with 3Ware 6400 3W-6400?
Date: Sat, 28 Jun 2003 14:40:33 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <14152929388.20030628144033@mail.ru>
References: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
 <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
 <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
 <Pine.LNX.4.55.0306271540140.6883@datavibe.net>
Reply-To: Alex Verbitsky <alexver5@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0306271540140.6883@datavibe.net>
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Rev. Jeffrey Paul,

Friday, June 27, 2003, 10:45:08 PM, you wrote:
RJP> Exactly.  Another issue is that I want them to be able to just swap out
RJP> (not necessarily hot, but offline even) a failed drive without my
RJP> intervention.... I assume the card will just resync it?  Under linux, it'd
RJP> require mucking about with mdadm or the raidtools and I want this to be a
RJP> fire-and-forget kind of system.  On solid hardware on a UPS, the only
RJP> things likely to die are the processor fan, the power supply, and the
RJP> drives...  all of which can be replaced with no knowledge of the raid or
RJP> software configuration.
you are wrong that 3ware card automatically resync replaced drive. I've
done some research with 7500-8 and it showed that:
1) 3ware card doesn't detect that drive was inserted - you should
   manually add it to the list using 3DM or CLI
2) after you added the drive you should _manually_ start rebuilding
   the array with that drive again using 3DM or CLI
3) OR you have to go to 3ware BIOS on boot - then new drive will be
   detected automatically and you just have to start rebuilding with ths
   drive. BUT:
      - after reboot rebuild will continue on first array access
        (mounting volume or running fdisk) not on start-up
      - if you reboot after drive swap and do nothing in BIOS you will
        not be able to use newly inserted drive for array rebuild
        since BIOS adds it as independed 1-disk JBOD array.
        Until 7.6 3ware software you had to go to 3ware BIOS in this
        situation. With 7.6 software you can handle this since add and
        delete array commands are now available.

I am not 100% sure about 1) since i did not have a chance to test it with
3ware drive cage (which might have some logic for signaling drive
inesrtion to the card), but on the hand i looked through 3ware manual and
did not see any mention of auto-detection - only manual operations.

If you think i'm wrong or have any info on this I am all ears.

I believe that is possible to create some set of scripts for
monitoring 3ware array and auto-resyncng replaced drive but that would
be limited to single array on card i think.
Actually i am now trying to write script of this kind using perl and CLI.

-- 
Best regards,
 Alex                            mailto:alexver5@mail.ru

