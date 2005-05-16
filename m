From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Mon, 16 May 2005 18:11:32 -0400
Message-ID: <1116281492.13780.109.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-05-13 at 13:11 -0400, Doug Ledford wrote:

> > devices=/dev/md3,/dev/md2,/dev/md1,/dev/md0,/dev/md3,/dev/md2,/dev/md1,/dev/md0

OK, this particular little oddity is caused by the mdadm.conf file's
DEVICES= line containing both partitions and md[0-3].  Evidently mdadm
scans devices twice if they are both in the /proc/partitions file and
explicitly specified on the DEVICES= line.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


