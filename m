From: <martin@hack.org>
Subject: Re: md device stuck!
Date: Wed, 31 Jul 2002 10:41:05 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.32.0207311023550.5299-100000@dope.pingdynasty.com>
References: <15687.7740.359627.282411@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15687.7740.359627.282411@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Wed, 31 Jul 2002, Neil Brown wrote:

> You didn't say which kernel you are running ......

sorry, it's a 2.4.4 on alpha 21264

> and you don't have a correct System.map file.  There is no-way that
> mdadm will be blocked in ptrace.

you're perfectly right! fixed that, now it blocks on down_f (?!)

000 D root      4438     1  0  72   0 -   220 down_f Jul29 ?        00:00:00 mdadm --stop /dev/md2

but maybe that's a lingering problem from the previous shenanigans.
unfortunately i can't reboot the machine at the moment, but i guess these
probs will go away when i do.

think this is how it first got stuck, on umount ->

Jul 29 15:19:47 dope kernel: kernel BUG at inode.c:489!
Jul 29 15:19:47 dope kernel: umount(4290): Kernel Bug 1
Jul 29 15:19:47 dope kernel: pc = [copy_strings+272/784]  ra = [copy_strings+260/784]  ps = 0000
Jul 29 15:19:47 dope kernel: v0 = 000000000000001b  t0 = 0000000000000001  t1 = 0000000000000001
Jul 29 15:19:47 dope kernel: t2 = fffffc00009f31b0  t3 = fffffc0000a1bb08  t4 = 0000000000000000
Jul 29 15:19:47 dope kernel: t5 = fffffc00271ad0c0  t6 = 0000000000000065  t7 = fffffc00130cc000
Jul 29 15:19:47 dope kernel: a0 = 0000000000000000  a1 = 0000000000000001  a2 = 0000000000000001
Jul 29 15:19:47 dope kernel: a3 = fffffffffffffff9  a4 = 0000000000000002  a5 = 0000000000000002
Jul 29 15:19:47 dope kernel: t8 = 0000000000003fff  t9 = fffffc0000a1b3e0  t10= fffffc0000a1c890
Jul 29 15:19:47 dope kernel: t11= 000000000000000a  pv = fffffc000081d980  at = 0000000000000000
Jul 29 15:19:47 dope kernel: gp = fffffc0000a15f28  sp = fffffc00130cfdf8
Jul 29 15:19:47 dope kernel: Code: 225f01e9  lda a2,489(zero)
Jul 29 15:19:47 dope kernel:  a77da4d8  ldq pv,-23336(gp)
Jul 29 15:19:47 dope kernel:  6b5b663f  jsr ra,(pv)
Jul 29 15:19:47 dope kernel:  27ba001b  ldah gp,27(ra)
Jul 29 15:19:47 dope kernel:  23bde9d4  lda gp,-5676(gp)
Jul 29 15:19:47 dope kernel:  00000081  call_pal 129
Jul 29 15:19:47 dope kernel: *a44901c8  ldq t1,456(s0)
Jul 29 15:19:47 dope kernel:  44421001  and t1,16,t0
Jul 29 15:19:47 dope kernel:
Jul 29 15:19:47 dope kernel: Trace:          86769c           8678ac           852934           852f28           8530a8           810a80


assuming linux/fs/inode.c, here's the context:

/**
 * clear_inode - clear an inode
 * @inode: inode to clear
 *
 * This is called by the filesystem to tell us
 * that the inode is no longer useful. We just
 * terminate it with extreme prejudice.
 */
void clear_inode(struct inode *inode)
{
        invalidate_inode_buffers(inode);

        if (inode->i_data.nrpages)
                BUG();
        if (!(inode->i_state & I_FREEING))
line 489 ->>>   BUG();
        if (inode->i_state & I_CLEAR)
                BUG();
        wait_on_inode(inode);
        if (IS_QUOTAINIT(inode))
                DQUOT_DROP(inode);
        if (inode->i_sb && inode->i_sb->s_op &&
inode->i_sb->s_op->clear_inode)
                inode->i_sb->s_op->clear_inode(inode);
        if (inode->i_bdev) {
                bdput(inode->i_bdev);
                inode->i_bdev = NULL;
        }
        inode->i_state = I_CLEAR;
}



/m

