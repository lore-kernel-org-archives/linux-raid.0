From: Phil Turmel <philip@turmel.org>
Subject: Re: Is It Hopeless?
Date: Mon, 27 Dec 2010 00:35:03 -0500
Message-ID: <4D182587.4040801@turmel.org>
References: <201012261019.56481.CACook@quantum-sci.com> <201012261219.41912.CACook@quantum-sci.com> <20101227073330.6acb577a@notabene.brown> <201012261606.29281.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012261606.29281.CACook@quantum-sci.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/26/2010 07:06 PM, Carl Cook wrote:
> On Sun 26 December 2010 12:33:30 Neil Brown wrote:
>> But the important thing is that you have your data back, preparing
>> you for a Happy New Year!
>> NeilBrown
> Indeed.  Thank you Neil, you saved me (along with my not touching
> anything).

> On Sun 26 December 2010 13:14:32 you wrote:
>> Excellent save!!!  The OP might want to continue the "Giving
>> Season" by giving himself a brand new system backup.

> Actually I have much too much data to back anything up, so I've been
> stalling for over a year on building a backup server.  It's fixin' to
> happen now, you betcha.  A cube case with ITX and a BTRFS array the
> same size as my RAID10.  NoMachine NX over SSH for admin.  It'll be
> in a far corner of the garage down low, so if a fire or theft I don't
> lose my data.  I'll sync it with the main over GBethernet, at some
> interval, in some way (suggestions?), but keep it offline most of the
> time.  All my systems are named after constellations, so this will be
> called "Gemini". (the twin)

(Heh.  I name my systems after constellations, too.)

I, too, use an alternate server to back up to, but my daily changes are small enough to rsync over the net.  To reduce the chance of double failures in my arrays, a cron job kicks off a "resync" weekly.  I also use a super-cheap SATA hot-swap bay (carriage-less) to support weekly and monthly rotations to a fire safe at a third site.  Although Stan is right that tape is the best choice for really large backups, I find the commodity 1.5T drives hard to beat for convenience.

Just my $0.02.

HTH,

Phil
