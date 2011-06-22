From: Phil Turmel <philip@turmel.org>
Subject: Re: reaid problem at reboot
Date: Tue, 21 Jun 2011 23:53:37 -0400
Message-ID: <4E016741.8080606@turmel.org>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org> <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>,<4E0113FE.503@turmel.org> <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>,<4E0146B6.40101@turmel.org> <BAY158-w9526A91B9B67956C12924C0500@phx.gbl>,<4E0153C1.1040708@turmel.org> <BAY158-w1B10F98EB9026A0F3D50CC0500@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY158-w1B10F98EB9026A0F3D50CC0500@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: william L'Heureux <wil_c_will@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/21/2011 11:34 PM, william L'Heureux wrote:
> 
> /dev/sdj1 cant be first, its /dev/sda1.

'j' had the lvm metadata in the right spot.  It was first.  If it's not now, then your partial rebuild scrambled it.  I don't think I have any more expertise to offer at this point.

> My friend made a python script. take a look.
> 
> cat rebuild.py

[...]

Nice to automate the search, especially with many combinations.

> i can see the data with the combinatin below, but there is a lot of errors, sounds like a rebuild was started(beghining of the disk) then was canceled

That hurts.

> we made a snapshot, run a e2fsck on it and im still(not now, gotta sleep) add 1 missing or 2. after the e2fsck i mount the snap, look at the data, check corruption, rince and repeat with another combination of missing and not. i rate the ones with less corruption
> 
> the only e2fsck working is with --->>> a,j,c,h,i,d

Good luck.

Phil
