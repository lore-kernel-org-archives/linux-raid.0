From: Bruce Stenning <b.stenning@indigovision.com>
Subject: RE: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Date: Fri, 16 Dec 2011 16:23:17 +0000
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D9B2997C8@gretna.indigovision.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I wrote:
> Has anyone seen similar problems with RAID issues triggering this or
> similar BUG_ON statements in workqueue?  I have done some extensive
> web searching and delving through the latest git repositories, but
> have not found anything that stands out so far.

These problems have been tracked down to the following issue:

http://article.gmane.org/gmane.linux.raid/33553

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
