From: Marcus Sorensen <shadowsor@gmail.com>
Subject: combine multiple write-intent bitmaps
Date: Mon, 23 Jan 2012 13:38:58 -0700
Message-ID: <CALFpzo6sphj+bG3E-Z-Om3QXYWCOw2MoVTmKJeq8ciFe9K+0Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just theoretically, let's say that a system gets into a situation
where there are multiple file-backed write-intent bitmaps that belong
to the same array. Is there any way to combine them, or replay them
one at a time, so that all changes get replayed? Is there some
documentation on the bitmap file structure that would allow a tool to
be created that combines the bitmaps?
