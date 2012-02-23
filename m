From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Thu, 23 Feb 2012 01:57:25 +0000
Message-ID: <4F459D05.5060104@anonymous.org.uk>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com> <20120223090412.2b14fb7f@notabene.brown> <4F457758.8060807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F457758.8060807@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/2012 23:16, Jes Sorensen wrote:
[...]
> The goal was to try and reduce the number of bug reports over this by
> making it more obvious/explicit, so if you have a suggestion for how to
> do so in a better way, I am all game.

How about:

mdadm /dev/md0 --add %s
: %s was already a member of /dev/md0, attempting re-add
: Re-add failed because <reason>
: Not performing add as that would zero the superblock on %s and make it 
a spare
: mdadm --add used to do that automatically but it was potentially dangerous
: If that is what you really want to do, use mdadm --zero-superblock %s 
first.

