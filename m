From: Phil Turmel <philip@turmel.org>
Subject: Re: Reassemble Raid 6
Date: Mon, 10 Feb 2014 15:53:31 -0500
Message-ID: <52F93C4B.8000909@turmel.org>
References: <em138f8d3b-69b5-40ed-baf9-c23fb4e7ae1b@littlez>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em138f8d3b-69b5-40ed-baf9-c23fb4e7ae1b@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2014 11:48 AM, Justin Stephenson wrote:
> Hello,
> 
> I have reviewed the Linux Raid Wiki regarding rebuilding and it
> recommended writing a note to the list.
> 
> I am running an mdadm raid on CENTOS 6.5 with 6 disks in a Raid 6 off of
> my motherboard's SATA controller.
> 
> I added a 7th disk as a spare.
> 
> When I rebooted the raid after adding the spare, it would not mount and
> the OS would only boot into recovery mode. I changed my fsck file to
> exclude the raid and can now boot into the GUI.
> 
> I have tried to reassemble the array using --assemble and I get the the
> following message:
> 
> mdadm: we match both /dev/md/BigBlue:0 and /dev/md0 - cannot decide
> which to use.

Please show the output of your mdadm.conf file, and the complete command
you used to assemble with.  Add "-v" to it to show more information.

{There's nothing wrong with your array, just conflicting info in your
configuration file.}

Phil
