From: Miroslav 'Sirka' Hrachovec <hrachovm@sirka.cz>
Subject: Simple syntax error in raidtools-1.00.3
Date: Sun, 22 Feb 2004 19:19:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040222181925.GA26212@darkslum.inway.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just found an error in mkraid.c line 174.
There is an huge multiline string constant
and it have no '\' on ends of lines.
GCC 3.3.2 refuse to compile it. Adding the
'\' chars fix the problem.

best Regards,
Miroslav Hrachovec
