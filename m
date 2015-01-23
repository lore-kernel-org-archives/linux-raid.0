From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Fri, 23 Jan 2015 10:11:29 -0500
Message-ID: <20150123101129.5c56dd6e@jlaw-desktop.mno.stratus.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141117100349.1d1ae1fa@notabene.brown>
	<54B663EC.8090607@redhat.com>
	<20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com>
	<2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com>
	<20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
	<1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com>
	<20150119125650.22a75dd3@jlaw-desktop.mno.stratus.com>
	<1063248306.12205209.1421738206544.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1063248306.12205209.1421738206544.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

On Tue, 20 Jan 2015 02:16:46 -0500
Xiao Ni <xni@redhat.com> wrote:
> Joe
> 
>    Thanks for the explanation. So echo "idle" to sync_action is a workaround
> without the patch. 
>  
>    It looks like the patch is not enough to fix the problem. 
> Do you have a try with the new patch? Is the problem still exist in
> your environment?
> 
>    If your environment have no problem, can you give me the version number? I'll 
> have a try with the same version too. 

Hi Xiao,

Bill and I did some more testing yesterday and I think we've figured
out the confusion.  Running a 3.18+ kernel and an upstream mdadm, it
was the udev invocation of "mdadm -If <dev>" that was automatically
removing the device for us.

If we ran with an older mdadm and got the MD wedged in the faulty
condition, then nothing we echoed into the sysfs state file ('idle'
'fail' or 'remove')  would change anything.  I think this agrees with
your testing report.

So two things:

1 - Did you make / make install the latest mdadm and see it try to run
mdadm -If on the removed disk?  (You could also try manually running
it.)

2 - I think the sysfs interface to the removed disks is still broken in
cases where (1) doesn't occur.

Thanks,

-- Joe
