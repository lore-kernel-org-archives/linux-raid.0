From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: A few mdadm questions
Date: Sat, 13 Nov 2004 18:32:19 +1100
Message-ID: <16789.47235.818038.175157@cse.unsw.edu.au>
References: <419580D8.1020900@osiel.org>
	<200411130421.iAD4LwN03759@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Friday November 12
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Robert Osiel' <bob@osiel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 12, bugzilla@watkins-home.com wrote:
> First, stop using the old raid tools.  Use mdadm only!  mdadm would not have
> allowed your error to occur.

I'm afraid this isn't correct, though the rest of Guy's advice is very
good (thanks Guy!).

  mdadm --remove
does exactly the same thing as
  raidhotremove

It is the kernel that should (and does) stop you from hot-removing a
device that is working and active.  So I'm not quite sure what
happened to Robert...

Robert: it is always useful to provide specific with the output of 
    cat /proc/mdstat
and
    mdadm -D /dev/mdX

This avoids possible confusion over terminology.

NeilBrown
