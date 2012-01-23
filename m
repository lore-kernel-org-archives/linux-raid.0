From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 19:05:32 +0100
Message-ID: <4F1DA16C.7030202@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com> <4F1D89B9.9080802@redhat.com> <4F1D8D27.5070207@redhat.com> <4F1D905C.1050300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D905C.1050300@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/23/12 17:52, Doug Ledford wrote:
>> Kay suggested --preroot on irc - would that do the job? I think that is
>> > a bit better than --offroot.
> I'd say preroot is better than preboot for sure.  I think I still like
> offroot more than preroot though.  We *are* running off root (from the
> initramfs, and we are modifying our argv[0] to signal to systemd that we
> are doing exactly this).  We *are* keeping our files off of root (in
> /run/mdadm versus /var/run/mdadm).  And we are intending to live both
> before root (preroot) and also after root (postroot).  So, I find
> preroot to be better than preboot, but still not as accurate as offroot.
>  Offroot fairly accurately captures what we are doing (although it
> doesn't speak to the expected life span of the action, nor does it speak
> to the fact that we stay off root only if we are invoked from what will
> become the non-root fs, so some sort of check to make sure we are
> actually in an initrd/initramfs of sorts might be nice, but I'm not sure
> how that would play with things like USB live images where you might
> actually want to use the option on a non-initrd environment), where as
> both preboot and preroot speak as to when it is used, but not what it
> does nor the expected life span of the action.

Ok, I guess it depends a bit on how one thinks of it, ie. whether
thinking in the context of how it was launched or the system state. I am
not really biased one way or another, I mostly care about the
functionality, so I am going to wait until tomorrow and see what other
input we get and what Neil has to say.

Once we have a consensus, I'll cook up a v3 of the patches to match that.

Cheers,
Jes

