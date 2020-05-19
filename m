From: dfavro@meta-dynamic.com
Subject: [PATCH] mdadm: detect too-small device: error rather than underflow/crash
Date: Tue, 19 May 2020 14:58:11 -0400
Message-ID: <20200519185812.979553-1-dfavro@meta-dynamic.com>
References: <8c7c42f8-2040-859b-d558-0b523f7092d8@trained-monkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c7c42f8-2040-859b-d558-0b523f7092d8@trained-monkey.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cheerfully re-sent using git-send-email as the MSA.

Just to clarify, before I sent the original email, I verified that
it applied cleanly as-is with "git am -c" (I then deliberately
mentioned the scissors line in the message so that you would know
to include the -c option to git-am).  I will of course in the
future use git-send-email as you prefer -- but there was never any
need to "manually take it apart to apply it".

Let me know what else about the patch needs improvement.

Thank you,
David
