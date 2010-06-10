From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Detecting array parameters
Date: Thu, 10 Jun 2010 18:04:48 -0500
Message-ID: <A4.C2.03943.B9F611C4@cdptpa-omtalb.mail.rr.com>
References: <20100609211340.GA12172@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100609211340.GA12172@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: 'Piergiorgio Sartor' <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi,
> 
> if I understood it correctly, in order to detect
> the several array parameters (number of disks, for
> example), it is possible to use "mdadm -D /dev/mdX"
> or to check the files in the corresponding /sys/block/...
> /mdX/... files.

	Yes, but only if the array is assembled.  If not, it's "-E", not
"-D", and the target is a member device, not the array.

> Now, assuming something needs to be done in scripts,
> what would be the best way? Using "mdadm -D ... | grep"
> (or "mdadm ... | gawk ...."), or to read the proper
> files in /sys/block/md...?

	That depends on what you need to do.  If you need to obtain in depth
information about the array and / or act only upon specific contents of a
line in  the output, then you need to use gawk.  If your script merely takes
action based upon the existence of some meta-content of the output, then
grep or even grep -q may be the better choice.

> Assuming the wanted information is available on both
> sides, which does not seem always the case.

	I don't know what you mean by "both sides".

