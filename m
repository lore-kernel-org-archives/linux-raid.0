From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: reconstruction -- where is the upper bound?
Date: 28 Oct 2003 14:58:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067371114.24429.42.camel@opus>
References: <bWpzdHVtcGY=.2225bde2e3ae0856f1ad7359480d334c@1067370925.cotse.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.2225bde2e3ae0856f1ad7359480d334c@1067370925.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-10-28 at 14:55, mjstumpf wrote:
> I'm considering my options; currently I've got a server running on a
> p2-400.  What causes the upper bound--IO bandwidth or CPU speed--with
> regard to reconstruction of an array (say, a failed drive)?
> 
> I forget the numbers I usually see, because I do this a lot.  But it seems
> to me it has more to do with IO bandwidth than CPU horsepower.  I've done
> this with both SCSI and ATA, but currently I'm referring to an ATA system.
> 
> True?
> 
> Is there anything I can do to speed this up

cd /proc/sys/dev/raid/
cat speed_limit_max
echo numberinKB/s > speed_limit_max

-sv


