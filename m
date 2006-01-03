From: Roger Willcocks <willcor@gmail.com>
Subject: mdadm-2.2 typo
Date: Tue, 3 Jan 2006 16:48:19 +0000
Message-ID: <cfac95650601030848g3c4aa3b9h77b4dfa0ca2d2e2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm-2.2/super1.c line 384:

        if (strcmp(update, "uuid") == 0)
                memcmp(sb->set_uuid, info->uuid, 16);

should probably be memcpy

--
Roger
