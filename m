From: "Guy" <bugzilla@watkins-home.com>
Subject: Automatic Write Reallocation Enable, question?
Date: Sun, 16 Nov 2003 19:46:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200311170047.hAH0l2E15254@www.watkins-home.com>
References: <20031114182927.GA8810@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031114182927.GA8810@gtf.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

My hard disks support some programmable options.

Automatic Write Reallocation Enable (AWRE):
  On, drive automatically relocates bad blocks detected during write
operations.  Off, drive creates Check Condition status with sense key of
Medium Error if bad blocks are detected during write operations.

Automatic Read Reallocation Enable (ARRE):
  On, drive automatically relocates bad blocks detected during read
operations.  Off, drive creates Check Condition status with sense key of
Medium Error if bad blocks are detected during read operations.

These options are both off.

Would md be happier if these were on?  This would hide recoverable errors
from md.

Any opinions?

My disks are ST118202LC.

Thanks.
