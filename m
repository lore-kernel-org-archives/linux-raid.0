From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Determining which spindle is out of order
Date: Sun, 7 Nov 2010 14:46:22 -0600
Message-ID: <B9.A1.19545.A1017DC4@cdptpa-omtalb.mail.rr.com>
References: <4CD6F259.6080408@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6F259.6080408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Sunday, November 07, 2010 12:39 PM
> To: John Robinson
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Determining which spindle is out of order
> 
> On 11/07/2010 10:19 AM, John Robinson wrote:
> > On 07/11/2010 14:43, Phil Turmel wrote:
> >> On 11/07/2010 08:43 AM, John Robinson wrote:
> > [...]
> >>> Please don't feel you have to turn this into a project, though.
> >>
> >> Too late.  Here's a version that doesn't use udevadm at all...
> >
> > OK, it's an improvement because after I've changed the find command to
> find '*scsi_host*', it lists my controllers, but finds them all empty. I
> noted that the script was looking for subdirectories called block but mine
> have names like block:sda so I changed the script again to refer to
> 'block*' both in the loop in check_host and in the substitution at the top
> of describe_device. There's still something not quite right with trying to
> read CentOS/RHEL 5 / kernel 2.6.18 sysfs, because this was the output I
> got:
> 
> I think I understand the older sysfs directory format now.
> 
> > Hope this helps. I've also attached my edited version of the script.
> 
> I did another version, with regular expressions to accommodate the
> variations.  Please give it a shot.

	The regular expression doesn't work, here, but the rest of the
script now works on the older server.  I replaced the find statement with

find /sys/devices/  -name "scsi_host*" |check_host

	and it works.

