From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: Tips for good hard drives for a home server
Date: Thu, 13 Nov 2008 13:39:49 +0100
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECFD0@SE-EX008.groupinfra.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>
 <A20315AE59B5C34585629E258D76A97C02A43936@34093-C3-EVS3.exchange.rackspace.com>
 <837a927a0811120631j4bf074d1s5eab70142a7173b2@mail.gmail.com>
 <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECE78@SE-EX008.groupinfra.com>
 <1E9B82E1-1C22-4BF6-A85B-B607AFBCB7CD@scotgate.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1E9B82E1-1C22-4BF6-A85B-B607AFBCB7CD@scotgate.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ferg <ferg@scotgate.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>
> Hi Andrew,
>
> I think you are going to need to duck with such a statement:
>


ive got a bit mouth and I don't always think before I speak.   Bad combination.

FYI I was reading the data sheet of the ES.2 drives (and data sheets from the other manufacturers) and they all say about 27-29 dB is the seek noise...not too shabby.  What is the decibel rating of the ES drives?

This with reliability...doesn't it depend on how you look at it?  I mean, 2 drives does increase the chances of one of them failing, but the data is mirrored...doesn't that mean that *recovery* of drive failure is increased, even if *reliability* is decreased?

--andrew

>
> >> Any reason you are using RAID 0 for your server? Normally when I
> >> think of a server reliability  comes to mind and RAID 0 doesn't
> >> offer any.
> >> I'm assumming you make nightly or weekly backups?
>
> > Im using RAID 0 because I am not willing to shell out for several
> > drives.  2 at once is my breaking point.  This is only a *home*
> > server, and in my opinion, I think im already being way more
> > conscious of reliability by choosing RAID 0 compared to average Joe
> > that goes for a Windows Home Server with a single hard drive
>
> RAID 0 is actually less reliable than a single drive.  Since you lose
> the array when any of the component drives dies, then the
> "reliability" is equal to the "reliability" of the least reliable
> drive divided by the number of drives you have.....!
>
> I've been watching this thread with interest as I'm about to replace a
> 4 disc RAID10 SCSI array for a home server with similar SATA drives.
> I'm probably going to go with the Seagate Barracuda ES 1TB drives
> (ST31000340NS ). Bit expensive for a home server, and they do not have
> a reputation as being quiet, but they should last me a good while....!
>
> Cheers
> Chris
>
> http://scotgate.org   AIM#fergycool   Skype#fergycool
> "cease to exist, giving my goodbye, drive my car into the ocean, you
> think
> I'm dead, but i sail away, on a wave of mutilation!"

