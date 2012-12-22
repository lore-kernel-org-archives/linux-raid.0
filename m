From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: Few questions about a raid array with 3 faulty spares
Date: Sat, 22 Dec 2012 23:06:17 +0000
Message-ID: <CAH-e9v+YKqVVDpxN6W21fpWOxaNhCs7kr0uKT+33XtN0PUfe-A@mail.gmail.com>
References: <CAH-e9vJ_WWAL=sabeoJ8ybM0Etbf5bcar1vnGWS9wrWJx=njTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vJ_WWAL=sabeoJ8ybM0Etbf5bcar1vnGWS9wrWJx=njTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I just had 3 drives on a raid6 array marked as failed all at the same time.
I think it's unlikely that all of the drives went bad at the same time
so I am thinking the reason could be that one of my sata controllers
died or something like that.

I am thinking about moving the disks to other sata ports and then try
to get the array running again. My question is what method I should
use,
force assemble? Re-add? Or something else?
Would a force assemble be enough to unmark the disks as faulty? If I
try to re-add, would it wipe the data on the drives? I'd rather not
get my drives wiped in the process (for obvious reasons).

And if anyone knows of a way I can furter investigate as of why the
drives just got marked as failed all of a sudden I'd appreciate the
help.
