//
//  Utility.swift
//  ReactiveExample
//
//  Created by David Levi on 1/26/19.
//  Copyright © 2019 CodeTank Labs LLC. All rights reserved.
//

import Foundation

func performBlock(_ block: @escaping () -> Void)
{
	DispatchQueue.main.async(execute: block);
}

func performBlockAndWait(_ block: @escaping () -> Void)
{
	DispatchQueue.main.sync(execute: block);
}

func performDelayedBlock(_ delay: TimeInterval, _ block: @escaping () -> Void)
{
	DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

func performBgBlock(_ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).async(execute: block);
}

func performBgBlockAndWait(_ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).sync(execute: block);
}

func performDelayedBgBlock(_ delay: TimeInterval, _ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay, execute: block)
}
