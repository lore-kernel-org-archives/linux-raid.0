From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 5/9] mdmon: mdmon_pid should return pid from
	either dir
Date: Wed, 3 Mar 2010 08:09:06 +0100
Message-ID: <20100303070906.GE21832@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <20100228144123.GA24781@maude.comedia.it> <20100228144340.GD24781@maude.comedia.it> <20100303125031.4ae998cb@notabene.brown> <20100303064403.GB21832@maude.comedia.it> <20100303175554.54a91d49@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100303175554.54a91d49@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 03, 2010 at 05:55:54PM +1100, Neil Brown wrote:
>On Wed, 3 Mar 2010 07:44:03 +0100
>Luca Berra <bluca@comedia.it> wrote:
>
>> On Wed, Mar 03, 2010 at 12:50:31PM +1100, Neil Brown wrote:
>> >On Sun, 28 Feb 2010 15:43:40 +0100
>> >Luca Berra <bluca@comedia.it> wrote:
>> >
>> >> mdmon_pid is called by mdmon_running to check if mdmon is running, so
>> >> the pid file should be checked in either VAR_RUN or ALT_RUN
>> >
>> >I don't agree with this.
>> >
>> >The only time that any code should care about ALT_RUN is when mdmon is
>> >starting.  It chooses VAR_RUN or ALT_RUN to use, and possibly looks for an
>> >old instance to kill.
>> >
>> >When starting mdmon without "--takeover", if it decided to use VAR_RUN, it
>> >would not check ALT_RUN to see if an old mdmon was running.  So I have
>> >replaced you patch with a patch to include that extra check when starting
>> >mdmon without --takeover.
>> >Maybe that is the case you intended to address??
>> 
>> No,
>> the problem i try to address is in mdadm, not mdmon
>> When mdadm needs to manage arrays with external metadata it will look
>> for mdmon using mdmon_running(). If mdmon is running but did not yet
>> take over mdadm will refuse to operate stating that mdmon is not
>> running.
>> 
>> I had to mount --bind ALT_RUN VAR_RUN in order to repair my imsm on
>> sunday morning.
>
>Ahhh..
>I would rather you did
>  mdmon --takeover --all
>
>which would effectively move the key fines from ALT_RUN to VAR_RUN.
>
>Would that have worked in your case?
>

Unfortunately I did not have the fortune of a writable /var/run at the
moment.
(that's what prompted me to add the check in another patch)

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
