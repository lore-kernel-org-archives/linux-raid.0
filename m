From: Joel Young <jdy@cryregarder.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Thu, 14 Mar 2013 04:02:15 +0000 (UTC)
Message-ID: <loom.20130314T050006-722@post.gmane.org>
References: <loom.20130314T022616-853@post.gmane.org> <13BA178C-2888-41FA-A237-13C1423794C4@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Murphy <lists <at> colorremedies.com> writes:
> On Mar 13, 2013, at 7:33 PM, Joel Young <jdy <at> cryregarder.com> wrote:
>> mdadm /dev/md0 --fail /dev/loop0
> 
> loop0 isn't defined in any of your raids.

typo when transcribing my history session.  There is no loop0.

mdadm /dev/md0 --fail /dev/loop1 
mdadm /dev/md0 --fail /dev/loop2

> > Shouldn't /dev/md2 be failed at this point?
> 
> No.

No.  But it was.  Sorry for the confusion with the typo.

Joel


