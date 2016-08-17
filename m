From: Maarten van Malland <maartenvanmalland@gmail.com>
Subject: Adding journal to existing raid5 arrary
Date: Wed, 17 Aug 2016 22:20:39 +0200
Message-ID: <CAC8wJ3FYKvdoLNmOerTgK+yd7p8ZhPXDLW0Z6V6Q+QpJb9MDMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was trying to add a previously created raid5 array with:

mdadm --add-journal /dev/md3 /dev/sdc

That gave an error though: "/dev/md3 does not support journal device
/dev/sdc". I'm guessing that happens because the initial array was created
without journal support? Is there anything I can do to get this to work
without recreating the entire array?
