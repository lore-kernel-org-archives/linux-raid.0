From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Detecting array parameters
Date: Sat, 12 Jun 2010 11:59:53 +0200
Message-ID: <20100612095953.GB14727@lazy.lzy>
References: <20100609211340.GA12172@lazy.lzy>
 <A4.C2.03943.B9F611C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A4.C2.03943.B9F611C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Piergiorgio Sartor' <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer.

By "both sides" I mean the "mdadm -D/-E" (one) and the
/sys/class/block/mdX/md (the other).

Some information is available with "mdadm -D", some other
is available in the sysfs.

bye,

pg

On Thu, Jun 10, 2010 at 06:04:48PM -0500, Leslie Rhorer wrote:
> > Hi,
> > 
> > if I understood it correctly, in order to detect
> > the several array parameters (number of disks, for
> > example), it is possible to use "mdadm -D /dev/mdX"
> > or to check the files in the corresponding /sys/block/...
> > /mdX/... files.
> 
> 	Yes, but only if the array is assembled.  If not, it's "-E", not
> "-D", and the target is a member device, not the array.
> 
> > Now, assuming something needs to be done in scripts,
> > what would be the best way? Using "mdadm -D ... | grep"
> > (or "mdadm ... | gawk ...."), or to read the proper
> > files in /sys/block/md...?
> 
> 	That depends on what you need to do.  If you need to obtain in depth
> information about the array and / or act only upon specific contents of a
> line in  the output, then you need to use gawk.  If your script merely takes
> action based upon the existence of some meta-content of the output, then
> grep or even grep -q may be the better choice.
> 
> > Assuming the wanted information is available on both
> > sides, which does not seem always the case.
> 
> 	I don't know what you mean by "both sides".
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
