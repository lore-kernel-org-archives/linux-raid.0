From: Luca Berra <bluca@comedia.it>
Subject: Re: problem with mdadm --incremental on ubuntu from initramfs
	(path choice related) on version 3.x
Date: Mon, 29 Mar 2010 22:01:30 +0200
Message-ID: <20100329200130.GA26734@maude.comedia.it>
References: <1269844303.26247.23.camel@travelmate.workshop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1269844303.26247.23.camel@travelmate.workshop>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 29, 2010 at 07:31:43AM +0100, Jools Wills wrote:
>i notice in the mdadm git head this has been changed to
>
>        mapnames(VAR_RUN "/map"),
>        mapnames("/var/run/mdadm.map"),
>        mapnames(ALT_RUN "/" ALT_MAPFILE)
>
>and the description has been almost corrected (albeit some typos) to
>
> *   /var/run/mdadm/map  /var/run/mdadm.map  /lib/initrw/madam/map
>
>however, these paths are still not helpful for the ubuntu initramfs that
>doesn't have these locations - and there is not an obvious fall back
>location.
i tought ubuntu had /lib/init/rw, being debian based, or is it only the
mdadm subdire under that one missing? current git should create the
latter.

>Also changing the ALT_RUN location will also change where it stores the
>PID for the monitor daemon, which is called much later once root is
>mounted, so even if ALT_RUN is set to /dev/ so the map file could be
>created. it wouldn't be the ideal location for the PID.
not exactly, mdmon is spawned by mdadm in case an array with external
metadata is assembled (imsm or ddf)

>Since things tend to fail if it cant make the mapfile how about it
>tries /dev/ as a final location for the file (or another location that
>is likely to exist) if the others fail? Another option that would work,
>is to create a folder such as /var/run if it is missing, or allow the
>map file path to be passed as a parameter, so the location guesswork
>could be overridden by the caller.
since ALT_RUN and VAR_RUN are settable at compile time, i believe every
distro can chose a suitable path.

>Also, some error reporting that the map file couldn't be created would
>be most useful, instead of the "/dev/md0 is in use" error.

yes, this would be needed

>My final thought is, that to make this bug report, I had to come and
>sign up here on this list, and then hope that the mdadm maintainer will
>read it. The mdadm software really needs a bugtracker, or better
>instructions on the site as to how to go about reporting issues.
What's wrong about a mailing list?

L.

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
