From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Fri, 16 Jan 2015 10:10:31 -0500
Message-ID: <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141029084113.57f6ae6a@notabene.brown>
	<20141029133604.59f9549a@jlaw-desktop.mno.stratus.com>
	<20141113090549.296a13ee@jlaw-desktop.mno.stratus.com>
	<20141117100349.1d1ae1fa@notabene.brown>
	<54B663EC.8090607@redhat.com>
	<20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com>
	<2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

On Fri, 16 Jan 2015 00:20:12 -0500
Xiao Ni <xni@redhat.com> wrote:
> 
> Hi Joe
> 
>    Thanks for reminding me. I didn't do that. Now it can remove successfully after writing
> "idle" to sync_action.
> 
>    I thought wrongly that the patch referenced in this mail is fixed for the problem.

So it sounds like even with 3.18 and a new mdadm, this bug still
persists?

-- Joe

