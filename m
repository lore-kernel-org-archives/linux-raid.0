From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Tue, 18 Feb 2003 18:59:05 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0302181851380.25817-100000@sweetums.bluetronic.net>
References: <20030202004849.GA28521@willow.seitz.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030202004849.GA28521@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: Jeffrey Paul <sneak@datavibe.net>, Stephan van Hienen <stephan@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003, Ross Vandegrift wrote:
>I Am Not an Electrican Engineer, But My Boss Is.  I did this once, and
>he had a cow.  There was some problem he yelled at me, having to do with
>different PSUs pulling voltage up at a different rate.  There's someway
>he said that the differential in voltages would feed back through the
>IDE channels, for some reason....
>
>The short of it was that someone qualified to judge said it was a really
>bad idea to use multiple seperate power supplies.

Ok, I'm gonna have to jump in here now.  People have been doing this for
DECADES with SCSI hardware.  It's a load of BS.  As long as there's a
common ground line, you won't release any smoke. (And I bet they have a
common ground through the AC plug.)

Can you say "external enclosure"?  I knew that you could.

(Note: only HVD SCSI hardware has line isolation circuits -- required per
       spec to avoid setting SE busses on fire if you plug the wrong thing
       in.)

--Ricky

PS: Yes, SCSI feeds power into the bus to power terminators. (usu. everything
    feeds power to the bus... common factory default)


